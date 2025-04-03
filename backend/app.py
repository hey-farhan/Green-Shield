
import io
import os
import json
import torch
import torch.nn as nn
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from PIL import Image
import uvicorn
import numpy as np
from torchvision import transforms

# Initialize FastAPI app
app = FastAPI(title="Plant Disease Detection API", 
              description="API for detecting plant diseases using PyTorch model",
              version="1.0.0")

# Configure CORS to allow requests from your Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You might want to restrict this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Model definition - exactly as in your training code
class PlantDiseaseModel(nn.Module):
    """Convolutional Neural Network for plant disease classification"""
    def __init__(self, num_classes, dropout_rate=0.5):
        super(PlantDiseaseModel, self).__init__()
        # Convolutional Block 1
        self.conv_block1 = nn.Sequential(
            nn.Conv2d(3, 64, kernel_size=3, padding="same"),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2)
        )
        # Convolutional Block 2
        self.conv_block2 = nn.Sequential(
            nn.Conv2d(64, 128, kernel_size=3, padding="same"),
            nn.BatchNorm2d(128),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2)
        )
        # Convolutional Block 3
        self.conv_block3 = nn.Sequential(
            nn.Conv2d(128, 256, kernel_size=3, padding="same"),
            nn.BatchNorm2d(256),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2)
        )
        # Convolutional Block 4
        self.conv_block4 = nn.Sequential(
            nn.Conv2d(256, 512, kernel_size=3, padding="same"),
            nn.BatchNorm2d(512),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2)
        )
        # Convolutional Block 5
        self.conv_block5 = nn.Sequential(
            nn.Conv2d(512, 512, kernel_size=3, padding="same"),
            nn.BatchNorm2d(512),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2)
        )
        # Global Average Pooling
        self.global_avg_pool = nn.AdaptiveAvgPool2d((1, 1))
        # Fully Connected Layers
        self.fc_block = nn.Sequential(
            nn.Flatten(),
            nn.Linear(512, 256),
            nn.ReLU(),
            nn.Dropout(dropout_rate),
            nn.Linear(256, num_classes)
        )

    def forward(self, x):
        x = self.conv_block1(x)
        x = self.conv_block2(x)
        x = self.conv_block3(x)
        x = self.conv_block4(x)
        x = self.conv_block5(x)
        x = self.global_avg_pool(x)
        x = self.fc_block(x)
        return x


# Global variables for model and class names
model = None
class_names = []
image_size = (256, 256)  # Same as in your training code

# Create the transformations directly in code
# These match the transforms used in your validation/test pipeline
inference_transform = transforms.Compose([
    transforms.Resize(image_size),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

# Image preprocessing function
def preprocess_image(image_bytes):
    """Process uploaded image bytes for model prediction"""
    # Open image
    image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    
    # Apply transform (same as in your test/validation pipeline)
    image_tensor = inference_transform(image).unsqueeze(0)
    
    return image_tensor

# Load the model and create class names on startup
@app.on_event("startup")
async def startup_event():
    global model, class_names
    
    try:
        # Define path to model
        model_path = 'best_model.pth'
        
        # Either load class names from file if available or define manually
        try:
            with open('class_names.json', 'r') as f:
                class_names = json.load(f)
        except FileNotFoundError:
            # If class_names.json is not available, you'll need to define your classes manually
            # Update this list with your actual disease classes
            class_names = [
                "Apple___Apple_scab",
                "Apple___Black_rot",
                "Apple___Cedar_apple_rust",
                "Apple___healthy",
                "Cherry___healthy",
                "Cherry___Powdery_mildew",
                "Corn___Cercospora_leaf_spot Gray_leaf_spot",
                "Corn___Common_rust",
                "Corn___healthy",
                "Corn___Northern_Leaf_Blight",
                "Grape___Black_rot",
                "Grape___Esca_(Black_Measles)",
                "Grape___healthy",
                "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)",
                "Peach___Bacterial_spot"
                # Add any additional classes your model was trained on
            ]
        
        # Initialize model with the correct number of classes
        num_classes = len(class_names)
        model = PlantDiseaseModel(num_classes=num_classes)
        
        # Load trained weights
        model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')))
        model.eval()
        
        print("✅ Model loaded successfully")
        print(f"✅ Loaded {num_classes} plant disease classes")
        
    except Exception as e:
        print(f"❌ Failed to load model: {e}")

# Health check endpoint
@app.get("/")
async def root():
    return {"status": "online", "message": "Plant Disease Detection API is running"}

# Prediction endpoint
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not file:
        raise HTTPException(status_code=400, detail="No file uploaded")
    
    # Validate file extension
    valid_extensions = ['.jpg', '.jpeg', '.png']
    file_ext = os.path.splitext(file.filename)[1].lower()
    if file_ext not in valid_extensions:
        raise HTTPException(
            status_code=400, 
            detail=f"Invalid file extension. Supported formats: {', '.join(valid_extensions)}"
        )
    
    # Read image file
    contents = await file.read()
    
    try:
        # Preprocess the image
        input_tensor = preprocess_image(contents)
        
        # Get the device
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        input_tensor = input_tensor.to(device)
        model.to(device)
        
        # Make prediction
        with torch.no_grad():
            outputs = model(input_tensor)
            probabilities = torch.nn.functional.softmax(outputs[0], dim=0)
            
            # Get predicted class index and confidence
            predicted_idx = torch.argmax(probabilities).item()
            predicted_class = class_names[predicted_idx]
            confidence = probabilities[predicted_idx].item() * 100
            
            # Create result with all class probabilities
            all_probs = {
                class_names[i]: round(float(prob) * 100, 2) 
                for i, prob in enumerate(probabilities)
            }
            
            # Sort probabilities for top predictions
            top_predictions = sorted(
                [(class_name, prob) for class_name, prob in all_probs.items()],
                key=lambda x: x[1],
                reverse=True
            )[:5]  # Get top 5
            
            result = {
                "prediction": predicted_class,
                "confidence": round(confidence, 2),
                "top_predictions": [
                    {"class": class_name, "probability": prob} 
                    for class_name, prob in top_predictions
                ],
                "all_probabilities": all_probs
            }
            
            return JSONResponse(content=result)
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

# Run the app
if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)