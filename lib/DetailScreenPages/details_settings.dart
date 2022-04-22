import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_transfer/DetailScreenPages/SettingScreens/change_password.dart';
import 'package:money_transfer/DetailScreenPages/SettingScreens/change_username.dart';
import 'package:money_transfer/Screens/home.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsSettings extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _logoutAction(BuildContext context) async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    showToast('signed out!');
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 55.0),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 2.0,
            child: Container(
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 5),
          SettingsButton(
              buttonText: 'Change username',
              buttonAction: () {
                Navigator.pushNamed(
                    context, ChangeUserNameScreen.changeUserNameScreenRoute);
              }),
          SettingsButton(
              buttonText: 'Change password',
              buttonAction: () {
                Navigator.pushNamed(
                    context, ChangePasswordScreen.changePasswordScreenRoute);
              }),
          SettingsButton(
              buttonText: 'Logout',
              buttonAction: () {
                _logoutAction(context);
              }),
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback buttonAction;
  SettingsButton({required this.buttonText, required this.buttonAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: buttonAction,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
