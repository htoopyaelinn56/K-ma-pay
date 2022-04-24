import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryData {
  final String toWho;
  final Timestamp timestamp;
  final int amount;

  HistoryData({
    required this.timestamp,
    required this.amount,
    required this.toWho,
  });
}
