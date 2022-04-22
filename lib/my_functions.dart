import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: componentColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<dynamic> getMyInfo(
    {String arg = 'gold' /* default arg is gold */}) async {
  dynamic myGold = 0;
  try {
    await for (var i in _db.collection('money').get().asStream()) {
      for (var i in i.docs) {
        if (i.get('email') == _auth.currentUser?.email) {
          myGold = i.get(arg);
        }
      }
    }
  } catch (e) {
    return null;
  }
  return myGold;
}

Future<String> getMyId() async {
  var myId;
  await for (var i in _db.collection('money').get().asStream()) {
    for (var i in i.docs) {
      if (i.get('email') == _auth.currentUser?.email) {
        myId = i.id;
      }
    }
  }
  return myId;
}

String generateGiftCard() {
  List<String> alphabets = [];
  for (int i = 65; i <= 90; i++) {
    alphabets.add(String.fromCharCode(i));
  }
  for (int i = 97; i <= 122; i++) {
    alphabets.add(String.fromCharCode(i));
  }
  for (int i = 0; i <= 9; i++) {
    alphabets.add(i.toString());
  }
  String card = '';

  for (int i = 0; i <= 25; i++) {
    card += alphabets[Random().nextInt(alphabets.length)];
  }
  return card;
}
