import 'package:flutter/material.dart';
import 'package:money_transfer/Components/my_buttons.dart';
import 'package:money_transfer/Screens/login_screen.dart';
import 'package:money_transfer/Screens/register_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypewriterAnimatedTextKit(
              text: const ['K Ma Pay'],
              textStyle: const TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.w800,
              ),
              speed: const Duration(milliseconds: 300),
            ),
            CustomButton(
                buttonText: 'Login',
                action: () {
                  Navigator.pushNamed(context, LoginScreen.loginScreenRoute);
                }),
            const SizedBox(height: 5),
            CustomButton(
                buttonText: 'Register',
                action: () {
                  Navigator.pushNamed(
                      context, RegisterScreen.registerScreenRoute);
                }),
          ],
        ),
      ),
    );
  }
}
