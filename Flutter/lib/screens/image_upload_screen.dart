import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? _imageBytes;
  String? _fileName;
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _fileName = picked.name;
        _loading = true;
      });

      try {
        final result = await ApiService.predictDisease(_fileName!, _imageBytes!);

        setState(() => _loading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(result: result, imageBytes: _imageBytes!),
          ),
        );
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🌿 Background Image
        SizedBox.expand(
          child: Image.asset("assets/leaf_bg.jpg", fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.black.withAlpha((255 * 0.6).round()),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: AppBar(
                backgroundColor: const Color(0xFF062743),
                elevation: 4,
                title: const Text(
                  'Upload Leaf Image',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (_imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(56),
                    child: Image.memory(_imageBytes!, height: 250, fit: BoxFit.cover),
                  )
                else
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(56),
                      color: Colors.white.withAlpha(200),
                      boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
                    ),
                    child: const Center(child: Text("No image selected")),
                  ),
                const SizedBox(height: 20),
                if (_loading) const CircularProgressIndicator(),
                if (!_loading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        onPressed: () => _pickImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF062743), // Catalina Blue
                          foregroundColor: Colors.white, // Text & icon color
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text('Gallery'),
                        onPressed: () => _pickImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF062743), // Catalina Blue
                          foregroundColor: Colors.white, // Text & icon color
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
