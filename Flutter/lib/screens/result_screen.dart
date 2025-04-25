import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../utils/solutions.dart';
import 'solution_screen.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final Uint8List imageBytes;

  const ResultScreen({super.key, required this.result, required this.imageBytes});

  bool get isValidPrediction {
    final pred = result['prediction'];
    return diseaseSolutions.containsKey(pred);
  }

  @override
  Widget build(BuildContext context) {
    final prediction = result['prediction'] ?? "Unknown";
    final confidence = result['confidence'] ?? 0.0;

    return Stack(
      children: [
        // 🌿 Background
        SizedBox.expand(
          child: Image.asset("assets/leaf_bg.jpg", fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.black.withAlpha(153), // semi-transparent dark bg
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
                  'Diagnosis Report',
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: Image.memory(imageBytes, height: 250),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prediction: $prediction",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Confidence: ${confidence.toStringAsFixed(2)}%",
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: isValidPrediction
                      ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SolutionScreen(prediction: prediction)))
                      : null,
                  icon: const Icon(Icons.local_hospital),
                  label: const Text("See Solution"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF062743),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
