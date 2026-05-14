import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'detection_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Translation Result"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔷 Language + confidence
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.blue),
                const SizedBox(width: 6),
                const Text("American Sign Language"),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Confidence: 98%"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔷 Translation card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TRANSLATION",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hello, how are you?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔷 Play button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.volume_up),
                    label: const Text("Play Voice"),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("Save"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("Share"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔷 Gestures
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Detected Gestures"),
                  SizedBox(height: 6),
                  Text("Hello, How, You"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔷 Retranslate
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DetectionScreen()),
                );
              },
              child: const Text("Retranslate"),
            ),

            const SizedBox(height: 16),

            // 🔷 Tip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Tip: Keep your hand clearly visible for better detection.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}