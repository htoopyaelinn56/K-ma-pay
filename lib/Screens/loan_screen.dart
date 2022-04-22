import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Components/my_buttons.dart';
import 'package:money_transfer/Components/reusable_check_pwd_modal.dart';
import 'package:money_transfer/DetailScreenPages/DetailsLoanScreenParts/get_loan_modal.dart';
import 'package:money_transfer/DetailScreenPages/DetailsLoanScreenParts/repay_loan.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:money_transfer/constants.dart';

class LoanScreen extends StatelessWidget {
  static String loanScreenRoute = 'loanScreenRoute';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Loan'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Loan Service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
          ),
          CustomButton(
            buttonText: 'Get Loan \$500',
            action: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => GetLoanModal(controller),
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          CustomButton(
            buttonText: 'Repay Loan',
            action: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => RepayLoanModal(controller),
              );
            },
          ),
        ],
      ),
    );
  }
}
