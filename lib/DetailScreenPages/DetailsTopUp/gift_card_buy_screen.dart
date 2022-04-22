import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_transfer/Components/error_dialog.dart';
import 'package:money_transfer/Components/my_buttons.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:provider/provider.dart';
import 'package:money_transfer/constants.dart';
import 'gift_card_buy_modal.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class GiftCardBuy extends StatelessWidget {
  static String giftCardBuyRoute = 'giftCardBuyRoute';
  TextEditingController _controller = TextEditingController();

  void buyLogic(BuildContext context) async {
    int selectedAmount =
        Provider.of<MyProvider>(context, listen: false).selectedGiftCardAmount;
    if (await getMyInfo() >= selectedAmount) {
      showModalBottomSheet(
        context: context,
        builder: (context) => BuyModal(
          controller: _controller,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          'No enough money!',
          (context) {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
              Provider.of<MyProvider>(context, listen: false).topUpPageTitle),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, left: 20),
              child: SizedBox(
                height: 150,
                width: 150,
                child: Image.network(
                    Provider.of<MyProvider>(context, listen: false)
                        .giftCardUrl),
              ),
            ),
            CustomRadioButton(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              spacing: 0,
              height: 50,
              horizontal: true,
              absoluteZeroSpacing: true,
              unSelectedColor: Colors.white,
              buttonLables: const [
                '10\$',
                '15\$',
                '25\$',
                '50\$',
                '100\$',
              ],
              buttonValues: const [
                10,
                15,
                25,
                50,
                100,
              ],
              buttonTextStyle: ButtonTextStyle(
                selectedColor: Colors.white,
                unSelectedColor: mainColor,
                textStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              radioButtonValue: (value) {
                Provider.of<MyProvider>(context, listen: false)
                    .selectedGiftCardAmount = int.parse(value.toString());
              },
              selectedColor: componentColor,
            ),
            SizedBox(
              height: 55,
              child: CustomButton(
                buttonText: 'Buy',
                action: () {
                  buyLogic(context);
                },
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
