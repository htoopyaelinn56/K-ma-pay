import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Components/my_buttons.dart';
import 'package:money_transfer/Components/text_field_widget.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart';
import 'dart:convert';

class TransferModel extends StatefulWidget {
  TextEditingController emailController;
  TextEditingController moneyController;

  TransferModel({required this.emailController, required this.moneyController});

  @override
  State<TransferModel> createState() => _TransferModelState();
}

class _TransferModelState extends State<TransferModel> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void transferProcess(BuildContext context) async {
    Provider.of<MyProvider>(context, listen: false)
        .checkTransferEmail(widget.emailController.text.trim());
    Provider.of<MyProvider>(context, listen: false)
        .checkTransferMoney(widget.moneyController.text);
    bool perfectCondition =
        !Provider.of<MyProvider>(context, listen: false).transferEmailError &&
            !Provider.of<MyProvider>(context, listen: false).transferMoneyError;

    setState(() {
      _isLoading = true;
    });
    if (perfectCondition) {
      if (_auth.currentUser?.email.toString() ==
          widget.emailController.text.trim()) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            'Cannot transfer self.',
            (context) {
              Navigator.pop(context);
            },
          ),
        );
      } else {
        int myGold = 0;
        int recipientGold = 0;
        await for (var i in _db.collection('money').get().asStream()) {
          for (var i in i.docs) {
            //find my gold
            if (i.get('email') == _auth.currentUser?.email.toString()) {
              myGold = i.get('gold');
              if (myGold >= int.parse(widget.moneyController.text)) {
                myGold = i.get('gold') - int.parse(widget.moneyController.text);
                await for (var i in _db.collection('money').get().asStream()) {
                  for (var i in i.docs) {
                    //find recipient
                    if (i.get('email') == widget.emailController.text.trim()) {
                      recipientGold = i.get('gold') +
                          int.parse(widget.moneyController.text);
                      //trade process //inc gold
                      await _db.collection('money').doc(i.id).update(
                        {
                          'gold': recipientGold,
                        },
                      );
                      await _db
                          .collection('history')
                          .doc(
                              '${widget.emailController.text.toString()} history')
                          .collection('history data')
                          .add(
                        {
                          //[time, amount, to/from whom]
                          'time': DateTime.now(),
                          'amount': int.parse(widget.moneyController.text),
                          'transfer': 'from ${_auth.currentUser!.email}',
                        },
                      );
                    }
                  }
                }
                await _db.collection('money').doc(i.id).update(
                  {
                    'gold': myGold,
                  },
                );
                await _db
                    .collection('history')
                    .doc('${_auth.currentUser!.email.toString()} history')
                    .collection('history data')
                    .add({
                  // data : [time, to who, amount]
                  'time': DateTime.now(),
                  'amount': int.parse(widget.moneyController.text),
                  'transfer': 'to ${widget.emailController.text}',
                });

                //push notification here
                await sendPushNotification([
                  widget.emailController.text.trimRight()
                ], 'Received ${widget.moneyController.text}\$ from ${_auth.currentUser!.email!}.',
                    'Money Received');
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    'Transferred successfully.',
                    (context) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    optionalTitle: 'Success',
                  ),
                );
                widget.emailController.text = '';
                widget.moneyController.text = '';
              } else {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    'Not enough money to transfer.',
                    (context) {
                      Navigator.pop(context);
                    },
                  ),
                );
              }
            }
          }
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<Response> sendPushNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "xx": "xx xx" // xxxxx is api key it can't be public
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        "include_external_user_ids": tokenIdList,
        "channel_for_external_user_ids": "push",
        "small_icon": "ic_stat_onesignal_default",
        "headings": {"en": heading},
        "contents": {"en": contents},
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      color: mainColor,
      progressIndicator: progressIndicator,
      child: Container(
        color: const Color(0xffff0b0c18),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          ),
          child: Center(
            child: Column(
              children: [
                MyTextField(
                  hintText: 'Recipient\'s E-mail',
                  controller: widget.emailController,
                  error: Provider.of<MyProvider>(context).transferEmailError
                      ? 'Invalid e-mail!'
                      : null,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  hintText: 'Amount to transfer',
                  controller: widget.moneyController,
                  error: Provider.of<MyProvider>(context).transferMoneyError
                      ? Provider.of<MyProvider>(context, listen: false)
                          .transferMoneyErrorMsg
                      : null,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  buttonText: 'Transfer',
                  action: () async {
                    List<String> emailList = [];
                    await for (var i
                        in _db.collection('money').get().asStream()) {
                      for (var i in i.docs) {
                        emailList.add(i.get('email'));
                      }
                    }
                    if (emailList
                        .contains(widget.emailController.text.trim())) {
                      transferProcess(context);
                    } else {
                      Provider.of<MyProvider>(context, listen: false)
                          .transferEmailInvokeError();
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
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
