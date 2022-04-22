import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:provider/provider.dart';

class MyInfoStream extends StatelessWidget {
  const MyInfoStream({
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
      stream: _db.collection('money').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: progressIndicator,
            ),
          );
        }
        var data = snapshot.data!.docs;
        String username = '';
        int gold = 0;
        String email = '';
        for (var i in data) {
          if (i.get('email') == _auth.currentUser?.email) {
            username = i.get('username');
            gold = i.get('gold');
            email = i.get('email');
          }
        }
        return Container(
          decoration: BoxDecoration(
            color: componentColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 5,
            bottom: 5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Provider.of<MyProvider>(context, listen: false).greetings,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Your balance',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Text(
                '${gold.toString()} \$',
                style: const TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
