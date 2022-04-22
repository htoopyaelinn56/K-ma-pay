import 'package:flutter/material.dart';
import 'package:money_transfer/constants.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback action;
  double width;
  double height;

  CustomButton({
    required this.buttonText,
    required this.action,
    this.width = double.infinity,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: ElevatedButton(
        onPressed: action,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(componentColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            Size(width, height),
          ),
        ),
      ),
    );
  }
}
