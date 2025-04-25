import 'package:flutter/material.dart';
import '../utils/solutions.dart';

class SolutionScreen extends StatelessWidget {
  final String prediction;

  const SolutionScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final solution = diseaseSolutions[prediction] ?? "No solution available.";

    return Stack(
      children: [
        // 🌿 Background image
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
                backgroundColor: const Color(0xFF062743), // Catalina Blue
                elevation: 4,
                title: const Text(
                  'Treatment Info',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(230),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Diagnosis: $prediction",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Suggested Treatment:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(solution, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
