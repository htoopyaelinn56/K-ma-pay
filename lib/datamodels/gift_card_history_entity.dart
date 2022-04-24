import 'package:cloud_firestore/cloud_firestore.dart';

class GiftCardHistoryEntity {
  final String cardCode;
  final String cardName;
  final int amount;
  final Timestamp timestamp;
  GiftCardHistoryEntity({
    required this.cardName,
    required this.cardCode,
    required this.amount,
    required this.timestamp,
  });
}
