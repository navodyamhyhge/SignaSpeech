// lib/services/firestore_service.dart
// Manages all Firestore database operations for translation history.
//
// Firestore Structure:
//   users/{userId}/history/{historyItemId}
//     - translatedText: String
//     - detectedGestures: String
//     - category: String
//     - direction: String
//     - timestamp: Timestamp
//     - confidence: double

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/history_item.dart';

class FirestoreService {
  // Singleton instance
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Reference helpers ─────────────────────────────────────────────────────

  /// Gets the current user's history collection reference.
  CollectionReference<Map<String, dynamic>>? get _historyCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('history');
  }

  // ── CRUD operations ───────────────────────────────────────────────────────

  /// Saves a translation result to Firestore history.
  Future<void> saveTranslation({
    required String translatedText,
    required String detectedGestures,
    required String category,
    String direction = 'ASL to English',
    double confidence = 0.95,
  }) async {
    final collection = _historyCollection;
    if (collection == null) return;

    await collection.add({
      'translatedText': translatedText,
      'detectedGestures': detectedGestures,
      'category': category,
      'direction': direction,
      'timestamp': Timestamp.now(),
      'confidence': confidence,
    });
  }

  /// Returns a real-time stream of history items, newest first.
  Stream<List<HistoryItem>> getHistoryStream() {
    final collection = _historyCollection;
    if (collection == null) return const Stream.empty();

    return collection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map(HistoryItem.fromFirestore).toList());
  }

  /// Fetches history once (no real-time updates).
  Future<List<HistoryItem>> getHistoryOnce() async {
    final collection = _historyCollection;
    if (collection == null) return [];

    final snapshot = await collection
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map(HistoryItem.fromFirestore).toList();
  }

  /// Deletes a specific history item by its document ID.
  Future<void> deleteHistoryItem(String itemId) async {
    await _historyCollection?.doc(itemId).delete();
  }

  /// Deletes all history for the current user.
  Future<void> clearAllHistory() async {
    final collection = _historyCollection;
    if (collection == null) return;

    final snapshot = await collection.get();
    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
