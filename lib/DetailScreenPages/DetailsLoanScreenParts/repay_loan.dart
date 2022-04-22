import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Screens/details_screen.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/my_functions.dart';

import '../../Components/reusable_check_pwd_modal.dart';

class RepayLoanModal extends StatefulWidget {
  TextEditingController controller = TextEditingController();

  RepayLoanModal(this.controller);

  @override
  State<RepayLoanModal> createState() => _RepayLoanModalState();
}

class _RepayLoanModalState extends State<RepayLoanModal> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool isLoading = false;

  void _repayLogic(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    bool hasLoan = await getMyInfo(arg: 'has_loan') ?? false;
    var myId = await getMyId();
    int myGold = await getMyInfo();
    try {
      await _auth.signInWithEmailAndPassword(
          email: _auth.currentUser!.email!, password: widget.controller.text);
      if (hasLoan) {
        if (await getMyInfo() >= 550) {
          _db.collection('money').doc(myId).update({
            'has_loan': false,
            'gold': myGold - 550,
          });

          await _db
              .collection('history')
              .doc('${_auth.currentUser!.email.toString()} history')
              .collection('history data')
              .add({
            // data : [time, to who, amount]
            'time': DateTime.now(),
            'amount': 550,
            'transfer': 'Repay Loan',
          });
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              'Borrowed credit is cleared.',
              (context) {
                Navigator.pushNamed(context, DetailsScreen.detailsScreenRoute);
              },
              optionalTitle: 'Repay Loan',
            ),
          );
          widget.controller.text = '';
        } else {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              'Not enough money!  Please top up.',
              (context) {
                Navigator.pop(context);
              },
            ),
          );
          widget.controller.text = '';
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'You do not have borrowed credit to repay.',
            (context) {
              Navigator.pop(context);
            },
            optionalTitle: 'No Loan',
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          'Wrong Password!',
          (context) {
            Navigator.pop(context);
          },
        ),
      );
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
      child: CheckPasswordModal(
        controller: widget.controller,
        buttonAction: () {
          _repayLogic(context);
        },
        buttonText: 'Repay Loan',
      ),
    );
  }
}
