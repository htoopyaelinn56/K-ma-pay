import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_transfer/datamodels/gift_card_history_entity.dart';
import 'package:money_transfer/my_functions.dart';

import '../../constants.dart';

class CreditCardHistoryScreen extends StatelessWidget {
  static String creditCardHistoryScreenRoute = 'creditCardHistoryScreen';

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Purchase History'),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _db
                .collection('history')
                .doc('${_auth.currentUser?.email} history')
                .collection('history data')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Center(
                    child: progressIndicator,
                  ),
                );
              }
              var data = snapshot.data!.docs;
              List<GiftCardHistoryEntity> ggList = [];
              for (var i in data) {
                var d = i.data() as Map;
                if (d['cardcode'] != null) {
                  ggList.add(
                    GiftCardHistoryEntity(
                      cardName: d['transfer'],
                      cardCode: d['cardcode'],
                      amount: d['amount'],
                      timestamp: d['time'],
                    ),
                  );
                }
              }
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _HistoryCard(
                        giftCardHistoryEntity: ggList, index: index);
                  },
                  itemCount: ggList.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final List<GiftCardHistoryEntity> giftCardHistoryEntity;
  final int index;

  _HistoryCard({
    required this.giftCardHistoryEntity,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      decoration: BoxDecoration(
        color: componentColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text('Card Name')),
              Expanded(child: Text(giftCardHistoryEntity[index].cardName)),
            ],
          ),
          Row(
            children: [
              const Expanded(child: Text('Card Cost')),
              Expanded(
                  child: Text(
                      '${giftCardHistoryEntity[index].amount.toString()} \$')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: Text('Card Code')),
              Expanded(
                child: FlatButton(
                  textColor: textColor,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: giftCardHistoryEntity[index].cardCode));
                    showToast('Copied!');
                  },
                  child: Text(
                    giftCardHistoryEntity[index].cardCode,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Expanded(child: Text('Time of purchase')),
              Expanded(
                child: Text(
                  giftCardHistoryEntity[index]
                      .timestamp
                      .toDate()
                      .toString()
                      .substring(0, 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
