import 'package:flutter/material.dart';
import 'package:money_transfer/constants.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? error;
  final bool isPwd;
  final TextInputType inputType;
  MyTextField({
    required this.hintText,
    required this.controller,
    required this.error,
    this.isPwd = false,
    this.inputType = TextInputType.emailAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        keyboardType: inputType,
        obscureText: isPwd,
        controller: controller,
        style: const TextStyle(
          fontSize: 24,
          height: 1.1,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          errorText: error,
          errorStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          labelText: hintText,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: componentColor,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: componentColor,
              width: 5.0,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
