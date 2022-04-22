import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_transfer/constants.dart';

class HistoryStream extends StatelessWidget {
  const HistoryStream({
    Key? key,
    required FirebaseFirestore db,
    required FirebaseAuth auth,
  })  : _db = db,
        _auth = auth,
        super(key: key);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
        if (data.isEmpty) {
          return Container(
            padding: const EdgeInsets.only(top: 70),
            child: const Center(
              child: Text(
                'No data',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        List<HistoryData> historyData = [];
        for (var i in data) {
          historyData.add(HistoryData(
              timestamp: i.get('time'),
              amount: i.get('amount'),
              toWho: i.get('transfer')));
        }
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              historyData[index].toWho,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              historyData[index].toWho.contains('from') ||
                                      historyData[index].toWho == 'Loan'
                                  ? '+${historyData[index].amount} \$'
                                  : '-${historyData[index].amount} \$',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              historyData[index]
                                  .timestamp
                                  .toDate()
                                  .toString()
                                  .substring(0, 16),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 10),
                      decoration: BoxDecoration(
                        color: componentColor,
                        borderRadius: index == 0 && historyData.length == 1
                            ? const BorderRadius.all(
                                Radius.circular(15),
                              )
                            : index == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )
                                : index == 14 || index == historyData.length - 1
                                    ? const BorderRadius.only(
                                        bottomRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      )
                                    : BorderRadius.zero,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
              itemCount: historyData.length > 15 ? 15 : historyData.length,
            ),
          ),
        );
      },
    );
  }
}

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
