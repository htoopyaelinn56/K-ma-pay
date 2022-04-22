import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:money_transfer/Components/error_dialog.dart';

import '../../Components/my_buttons.dart';
import '../../Components/reusable_check_pwd_modal.dart';

class BuyModal extends StatefulWidget {
  TextEditingController controller;
  BuyModal({required this.controller});

  @override
  State<BuyModal> createState() => _BuyModalState();
}

class _BuyModalState extends State<BuyModal> {
  bool isLoading = false;
  String giftCard = '';
  bool isFinished = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  void _payLogic(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: _auth.currentUser!.email!, password: widget.controller.text);

      int selectedAmount = Provider.of<MyProvider>(context, listen: false)
          .selectedGiftCardAmount;
      int myGold = await getMyInfo();
      int finalGold = myGold - selectedAmount;
      var myId = await getMyId();
      await _db.collection('money').doc(myId).update(
        {
          'gold': finalGold,
        },
      );
      String cardCode = generateGiftCard();
      await _db
          .collection('history')
          .doc('${_auth.currentUser!.email.toString()} history')
          .collection('history data')
          .add(
        {
          // data : [time, to who, amount]
          'time': DateTime.now(),
          'amount': selectedAmount,
          'transfer':
              Provider.of<MyProvider>(context, listen: false).topUpPageTitle,
          'cardcode': cardCode,
        },
      );
      showToast('Purchased successfully!');
      setState(() {
        giftCard = cardCode;
        isFinished = true;
      });
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
        controller: widget.controller,
        buttonAction: () {
          _payLogic(context);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        optionalWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              giftCard,
            ),
            Visibility(
              visible: isFinished,
              child: FlatButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: giftCard));
                  showToast('Copied!');
                },
                child: const Text(
                  'Copy',
                  style: TextStyle(color: Colors.lightBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
