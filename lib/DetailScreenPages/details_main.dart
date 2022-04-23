import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:money_transfer/Components/details_buttons.dart';
import 'package:money_transfer/DetailScreenPages/DetailsMainWidgets/transfer_modal.dart';
import 'package:money_transfer/DetailScreenPages/DetailsPayBill/bill_pay_screen.dart';
import 'package:money_transfer/DetailScreenPages/DetailsTopUp/top_up_page.dart';
import 'package:money_transfer/Screens/loan_screen.dart';
import 'package:money_transfer/constants.dart';
import 'DetailsMainWidgets/my_info_stream.dart';
import 'DetailsMainWidgets/history_stream.dart';

class DetailsHome extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30, top: 20),
          child: Text(
            'Logged in as ${_auth.currentUser?.email}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        MyInfoStream(db: _db, auth: _auth),
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 5,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DetailsButton(
                  buttonText: 'Transfer',
                  buttonAction: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => TransferModel(
                        emailController: _emailController,
                        moneyController: _moneyController,
                      ),
                    );
                  },
                  icon: Icons.arrow_forward,
                ),
              ),
              Expanded(
                child: DetailsButton(
                  buttonText: 'Loan',
                  buttonAction: () {
                    Navigator.pushNamed(context, LoanScreen.loanScreenRoute);
                  },
                  icon: Icons.local_atm,
                ),
              ),
              Expanded(
                child: DetailsButton(
                  buttonText: '   Gift\n Cards',
                  buttonAction: () {
                    Navigator.pushNamed(context, TopUpPage.topUpPageRoute);
                  },
                  icon: Icons.credit_card,
                ),
              ),
              Expanded(
                child: DetailsButton(
                  buttonText: 'Bill',
                  buttonAction: () {
                    Navigator.pushNamed(context, BillPay.billPayRoute);
                  },
                  icon: Icons.attach_money_outlined,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            color: componentColor,
          ),
        ),
        const Center(
          child: Text(
            'History Data',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: Text(
                  'Info',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        HistoryStream(db: _db, auth: _auth),
      ],
    );
  }
}
