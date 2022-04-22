import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Components/reusable_check_pwd_modal.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:provider/provider.dart';
import 'package:money_transfer/Components/my_buttons.dart';

class PayBillModal extends StatefulWidget {
  TextEditingController controller;
  PayBillModal(this.controller);

  @override
  State<PayBillModal> createState() => _PayBillModalState();
}

class _PayBillModalState extends State<PayBillModal> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  void _payBillLogic(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: _auth.currentUser!.email!, password: widget.controller.text);

      int myGold = await getMyInfo();
      var myId = await getMyId();
      if (myGold >=
          Provider.of<MyProvider>(context, listen: false).payBillObject!.cost) {
        int finalGold = myGold -
            Provider.of<MyProvider>(context, listen: false).payBillObject!.cost;

        await _db.collection('money').doc(myId).update(
          {
            'gold': finalGold,
          },
        );
        await _db
            .collection('history')
            .doc('${_auth.currentUser!.email.toString()} history')
            .collection('history data')
            .add({
          // data : [time, to who, amount]
          'time': DateTime.now(),
          'amount': Provider.of<MyProvider>(context, listen: false)
              .payBillObject!
              .cost,
          'transfer': Provider.of<MyProvider>(context, listen: false)
              .payBillObject!
              .name,
        });

        showToast('Paid Successfully.');
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'Not enough money. Please go to the office to pay.',
            (context) {
              Navigator.pop(context);
            },
          ),
        );
      }
      widget.controller.text = '';
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
        buttonAction: () {
          _payBillLogic(context);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.controller,
        optionalWidget: Text(
          'Cost : ${Provider.of<MyProvider>(context).payBillObject!.cost.toString()}\$',
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
