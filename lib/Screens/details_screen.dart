import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_transfer/DetailScreenPages/details_main.dart';
import 'package:money_transfer/DetailScreenPages/details_settings.dart';
import 'package:money_transfer/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DetailsScreen extends StatefulWidget {
  static String detailsScreenRoute = 'detailsScreenRoute';

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int currentIndex = 0;

  List<Widget> pagesList = [
    DetailsHome(),
    DetailsSettings(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
        body: pagesList.elementAt(currentIndex),
      ),
    );
  }
}
