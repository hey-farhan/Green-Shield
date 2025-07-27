# GreenShield 🌱

**GreenShield** is a cross-platform plant disease detection application built using **FastAPI** for the backend and **Flutter** for the frontend. It utilizes deep learning models trained on leaf images of **potato**, **tomato**, and **bell pepper** plants to classify them into healthy or disease-specific categories.

---

## 🚀 Features

- Detects diseases in **Potato, Tomato, and Bell Pepper** leaves
- Supports classification into **16 classes** (healthy and diseased)
- Includes an **out-of-distribution (OOD) filter model** to reject non-leaf images
- Cross-platform **Flutter app** for user-friendly interaction
- **FastAPI backend** serving PyTorch models with minimal latency

---

## 🧠 ML Models

- **Main Model**: Trained using PyTorch on leaf images categorized into:
  - ✅ Healthy
  - 🦠 Disease-specific classes (e.g., early blight, late blight)
- **OOD Filter Model**:
  - Classifies whether an uploaded image contains a valid leaf or not
  - Prevents false classifications from irrelevant inputs

---

## 🧱 Tech Stack

| Layer     | Stack                           |
|-----------|---------------------------------|
| Backend   | Python, FastAPI, PyTorch, Uvicorn |
| Frontend  | Flutter                         |
| Model     | Custom CNN / Transfer Learning (PyTorch) |
| Format    | REST APIs for predictions       |

---

## 📁 Project Structure

GreenShield/
├── backend/ # FastAPI server & ML models
├── frontend/ # Flutter mobile/web app
├── model/ # Jupyter notebooks for training
├── .gitignore
└── README.md


---

## ⚙️ Running the Project

### ✅ Backend (FastAPI)

1. Create a virtual environment:
    
   python -m venv venv
   source venv/bin/activate   # or venv\Scripts\activate on Windows


2.Install dependencies:

   pip install -r requirements.txt

3.Run the FastAPI server 

  uvicorn app:app --host 0.0.0.0 --port 8000

4.Visit http://localhost:8000/docs for Swagger UI / Postman 



##📱 Frontend (Flutter)

1.Navigate to the frontend/ folder:


2.Install Flutter dependencies:
flutter pub get

3.Run the app : 
flutter run

(NOTE : Change the address of localhost to your current IP address in the Flutter App)
---

🤝 Acknowledgements


Dataset: PlantVillage Dataset

PyTorch, FastAPI, Flutter, and community libraries
---

## 📜 License

This project is licensed under the [MIT License](./LICENSE).

You **must include** the following attribution if you use, distribute, or modify this project:

> Developed by [Farhan Inamdar](https://github.com/hey-farhan) as part of the **GreenShield** Leaf Disease Detection App.
