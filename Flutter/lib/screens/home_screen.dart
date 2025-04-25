import 'package:flutter/material.dart';
import 'image_upload_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🖼 Background Image
        SizedBox.expand(
          child: Image.asset('assets/leaf_bg.jpg', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.black.withAlpha(128),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Green Shield 🌿',
                    style: TextStyle(color: Colors.white, fontSize: 42)),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF062743),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Get Started', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ImageUploadScreen()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
