import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Components/my_buttons.dart';
import 'package:money_transfer/Components/text_field_widget.dart';
import 'package:money_transfer/my_functions.dart';
import 'details_screen.dart';
import 'package:provider/provider.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_transfer/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String loginScreenRoute = 'loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwdController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  void _inputAction(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    var providerData = Provider.of<MyProvider>(context, listen: false);
    providerData.checkLoginEmail(_emailController.text);
    providerData.checkLoginPwd(_pwdController.text);
    if (!providerData.loginPwdError && !providerData.loginEmailError) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _pwdController.text);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _auth.currentUser!.email!);
        //to next page
        Provider.of<MyProvider>(context, listen: false).greetings =
            'Welcome back';
        Navigator.pushNamed(
          context,
          DetailsScreen.detailsScreenRoute,
        );
      } on FirebaseException {
        showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return ErrorDialog(
              'Invalid e-mail or wrong password!',
              (context) {
                Navigator.pop(context);
              },
            );
          },
        );
        _pwdController.text = '';
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      color: mainColor,
      progressIndicator: progressIndicator,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                hintText: 'E-mail',
                controller: _emailController,
                error: Provider.of<MyProvider>(context).loginEmailError
                    ? 'Empty e-mail!'
                    : null,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                hintText: 'Password',
                controller: _pwdController,
                error: Provider.of<MyProvider>(context).loginPwdError
                    ? 'Empty password!'
                    : null,
                isPwd: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                buttonText: 'Login',
                action: () {
                  _inputAction(context);
                },
                width: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
