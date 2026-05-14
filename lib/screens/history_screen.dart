import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detection History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Color(0xFF9CA3AF)),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1F1B4E),
                  title: const Text('Clear History',
                      style: TextStyle(color: Colors.white)),
                  content: const Text('Delete all detection history?',
                      style: TextStyle(color: Color(0xFF9CA3AF))),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
              if (confirm == true && user != null) {
                final batch = FirebaseFirestore.instance.batch();
                final docs = await FirebaseFirestore.instance
                    .collection('detections')
                    .where('userId', isEqualTo: user.uid)
                    .get();
                for (var doc in docs.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();
              }
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(
        child: Text(
          'Please login to view history',
          style: TextStyle(color: Colors.white),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('detections')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No detections yet',
                    style: TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start detecting gestures!',
                    style: TextStyle(
                        color: Color(0xFF6B7280), fontSize: 13),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final gesture = data['gesture'] ?? 'Unknown';
              final confidence = (data['confidence'] ?? 0.0) as double;
              final timestamp = data['timestamp'] as Timestamp?;

              const emojis = {
                'Good Luck': '🤞',
                'Hello': '👋',
                'I Love You': '🤟',
                'No': '✋',
                'Please': '🙏',
                'Thank You': '🫶',
                'Thumbs Up': '👍',
                'Yes': '✊',
              };

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    // Emoji Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          emojis[gesture] ?? '🤚',
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Gesture name + time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gesture,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timestamp != null
                                ? _formatTime(timestamp.toDate())
                                : 'Just now',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Confidence badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(confidence * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}