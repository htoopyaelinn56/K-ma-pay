import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Components/my_buttons.dart';
import 'package:money_transfer/Components/text_field_widget.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:money_transfer/Screens/login_screen.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String changePasswordScreenRoute = 'changePasswordScreenRoute';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _currentPwdController = TextEditingController();

  TextEditingController _newPwdController = TextEditingController();

  TextEditingController _newRePwdController = TextEditingController();

  bool isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void passwordChange(BuildContext context) async {
    Provider.of<MyProvider>(context, listen: false)
        .chechChgPwdCurrentPwd(_currentPwdController.text);
    Provider.of<MyProvider>(context, listen: false)
        .checkChgTwoNewPwds(_newPwdController.text, _newRePwdController.text);

    setState(() {
      isLoading = true;
    });
    var provider = Provider.of<MyProvider>(context, listen: false);
    if (provider.chgPwdTwoPwdsSame &&
        !provider.chgPwdCurrentPwdError &&
        !provider.checkNewTwoPwds) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: _auth.currentUser!.email!,
            password: _currentPwdController.text);
        await _auth.currentUser!.updatePassword(_newPwdController.text);
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'New password \'${_newPwdController.text}\' changed successfully.\nPlease login again to continue. ',
            (context) {
              Navigator.pushNamed(context, LoginScreen.loginScreenRoute);
            },
            optionalTitle: 'Updated Password',
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'Wrong Password.',
            (context) {
              Navigator.pop(context);
            },
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: mainColor,
      progressIndicator: progressIndicator,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Change Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                MyTextField(
                  isPwd: true,
                  hintText: 'Current Password',
                  controller: _currentPwdController,
                  error: Provider.of<MyProvider>(context).chgPwdCurrentPwdError
                      ? 'Password can\'t be empty!'
                      : null,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  isPwd: true,
                  hintText: 'New Password',
                  controller: _newPwdController,
                  error: Provider.of<MyProvider>(context).checkNewTwoPwds
                      ? Provider.of<MyProvider>(context).chgPwdText
                      : null,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  isPwd: true,
                  hintText: 'Re-enter Password',
                  controller: _newRePwdController,
                  error: Provider.of<MyProvider>(context).checkNewTwoPwds
                      ? Provider.of<MyProvider>(context).chgPwdText
                      : null,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  buttonText: 'Change Password',
                  action: () {
                    passwordChange(context);
                  },
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
