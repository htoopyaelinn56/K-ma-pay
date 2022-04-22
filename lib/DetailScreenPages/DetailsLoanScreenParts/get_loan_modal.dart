import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_transfer/Screens/details_screen.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:money_transfer/constants.dart';
import '../../Components/reusable_check_pwd_modal.dart';
import 'package:money_transfer/Components/error_dialog.dart';

class GetLoanModal extends StatefulWidget {
  TextEditingController controller;
  GetLoanModal(this.controller);

  @override
  State<GetLoanModal> createState() => _GetLoanModalState();
}

class _GetLoanModalState extends State<GetLoanModal> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void _getLoanLogic(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    bool hasLoan = await getMyInfo(arg: 'has_loan') ?? false;
    int myGold = await getMyInfo();

    var myId = await getMyId();

    try {
      await _auth.signInWithEmailAndPassword(
          email: _auth.currentUser!.email!, password: widget.controller.text);
      if (!hasLoan) {
        _db.collection('money').doc(myId).update({
          'has_loan': true,
          'gold': myGold + 500,
        });

        await _db
            .collection('history')
            .doc('${_auth.currentUser!.email.toString()} history')
            .collection('history data')
            .add({
          // data : [time, to who, amount]
          'time': DateTime.now(),
          'amount': 500,
          'transfer': 'Loan',
        });
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'Received 500\$',
            (context) {
              Navigator.pushNamed(context, DetailsScreen.detailsScreenRoute);
            },
            optionalTitle: 'Loan Success',
          ),
        );
        widget.controller.text = '';
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'You have pending debt to repay!',
            (context) {
              Navigator.pop(context);
            },
          ),
        );
        widget.controller.text = '';
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          'Wrong Password',
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
          _getLoanLogic(context);
        },
        buttonText: 'Get Loan',
      ),
    );
  }
}
