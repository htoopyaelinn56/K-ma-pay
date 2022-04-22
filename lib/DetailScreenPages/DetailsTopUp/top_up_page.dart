import 'package:flutter/material.dart';
import 'package:money_transfer/DetailScreenPages/DetailsTopUp/gift_card_buy_screen.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:provider/provider.dart';
import 'top_up_item.dart';

class TopUpPage extends StatelessWidget {
  static String topUpPageRoute = 'topUpPageRoute';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Cards'),
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
