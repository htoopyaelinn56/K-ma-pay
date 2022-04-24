import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_transfer/DetailScreenPages/DetailsTopUp/credit_card_buy_history.dart';
import 'package:money_transfer/DetailScreenPages/DetailsTopUp/gift_card_buy_screen.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:money_transfer/my_functions.dart';
import 'package:provider/provider.dart';
import 'top_up_item.dart';

class TopUpPage extends StatelessWidget {
  static String topUpPageRoute = 'topUpPageRoute';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Cards'),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Card Purchased History',
              onPressed: () {
                Navigator.pushNamed(context,
                    CreditCardHistoryScreen.creditCardHistoryScreenRoute);
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return TopUpItems(
            cardList: cardList,
            itemIndex: index,
            buttonAction: () {
              Provider.of<MyProvider>(context, listen: false).topUpPageTitle =
                  cardList[index].name;
              Provider.of<MyProvider>(context, listen: false).giftCardUrl =
                  cardList[index].imgUrl;
              Navigator.pushNamed(
                context,
                GiftCardBuy.giftCardBuyRoute,
              );
            },
          );
        },
        itemCount: cardList.length,
      ),
    );
  }
}
