// lib/models/history_item.dart
// Data model for a single translation history entry stored in Firestore

import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryItem {
  final String id;
  final String translatedText;
  final String detectedGestures;
  final String category;      // e.g. "Daily Phrases", "Medical", "Work"
  final String direction;     // e.g. "ASL to English"
  final DateTime timestamp;
  final double confidence;

  const HistoryItem({
    required this.id,
    required this.translatedText,
    required this.detectedGestures,
    required this.category,
    required this.direction,
    required this.timestamp,
    required this.confidence,
  });

  // ── Firestore serialisation ───────────────────────────────────────────────

  factory HistoryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HistoryItem(
      id: doc.id,
      translatedText: data['translatedText'] ?? '',
      detectedGestures: data['detectedGestures'] ?? '',
      category: data['category'] ?? 'Daily Phrases',
      direction: data['direction'] ?? 'ASL to English',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      confidence: (data['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'translatedText': translatedText,
      'detectedGestures': detectedGestures,
      'category': category,
      'direction': direction,
      'timestamp': Timestamp.fromDate(timestamp),
      'confidence': confidence,
    };
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  /// Returns a human-readable relative date string like "Today, 2:45 PM"
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(timestamp.year, timestamp.month, timestamp.day);

    final timeStr =
        '${timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12}:'
        '${timestamp.minute.toString().padLeft(2, '0')} '
        '${timestamp.hour >= 12 ? 'PM' : 'AM'}';

    if (itemDay == today) return 'Today, $timeStr';
    if (itemDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $timeStr';
    }
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}, $timeStr';
  }

  // ── Static sample data for UI previews ───────────────────────────────────

  static List<HistoryItem> get sampleItems => [
    HistoryItem(
      id: '1',
      translatedText: 'Hello, how can I help you today?',
      detectedGestures: 'Hello, Help, You',
      category: 'Daily Phrases',
      direction: 'ASL to English',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      confidence: 0.98,
    ),
    HistoryItem(
      id: '2',
      translatedText: 'I need medical assistance immediately.',
      detectedGestures: 'Need, Medical, Help',
      category: 'Medical',
      direction: 'ASL to English',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      confidence: 0.96,
    ),
    HistoryItem(
      id: '3',
      translatedText: 'Where is the nearest restaurant?',
      detectedGestures: 'Where, Restaurant, Near',
      category: 'Travel',
      direction: 'ASL to English',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      confidence: 0.94,
    ),
    HistoryItem(
      id: '4',
      translatedText: "The meeting starts at nine o'clock.",
      detectedGestures: 'Meeting, Start, Nine',
      category: 'Work',
      direction: 'English to ASL',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      confidence: 0.97,
    ),
    HistoryItem(
      id: '5',
      translatedText: 'Could you please help me find the nearest subway?',
      detectedGestures: 'Request, Subway, Location',
      category: 'Travel',
      direction: 'ASL to English',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      confidence: 0.99,
    ),
  ];
}
