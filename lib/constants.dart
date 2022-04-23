import 'package:flutter/material.dart';
import 'package:money_transfer/datamodels/gift_card.dart';
import 'package:money_transfer/datamodels/pay_bill_object.dart';

Color mainColor = const Color(0xff181b35);
Color mainLightColor = const Color(0xffDEE4E7);
Color componentColor = Colors.indigo.shade900;
Color textColor = const Color(0xffffacceff);
var progressIndicator = const SizedBox(
  width: 50,
  height: 50,
  child: CircularProgressIndicator(
    color: Colors.white,
    strokeWidth: 5,
  ),
);

final List<GiftCard> cardList = [
  GiftCard(
      name: 'Google Gift Card',
      imgUrl:
          'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png'),
  GiftCard(
      name: 'X-box Gift Card',
      imgUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Xbox_one_logo.svg/1024px-Xbox_one_logo.svg.png'),
  GiftCard(
      name: 'Apple Gift Card',
      imgUrl:
          'https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-latest-apple-logo-icon-gif-15.png'),
  GiftCard(
      name: 'Spotify Gift Card',
      imgUrl:
          'https://www.freepnglogos.com/uploads/spotify-logo-png/spotify-download-logo-30.png'),
  GiftCard(
      name: 'Amazon Gift Card',
      imgUrl:
          'https://icones.pro/wp-content/uploads/2021/08/logo-amazon-orange.png'),
  GiftCard(
    name: 'Steam Gift Card',
    imgUrl:
        'https://www.freepnglogos.com/uploads/512x512-logo-png/512x512-logo-steam-ico-icons-and-png-backgrounds-24.png',
  ),
];

final List<PayBillObject> payBillList = [
  PayBillObject(
    name: 'Electricity Bill',
    icon: Icons.bolt,
    cost: 5000,
  ),
  PayBillObject(
    name: 'Insurance',
    icon: Icons.favorite,
    cost: 6000,
  ),
  PayBillObject(
    name: 'Wifi Bill',
    icon: Icons.wifi,
    cost: 300,
  ),
  PayBillObject(
    name: 'Phone Bill',
    icon: Icons.phone,
    cost: 100,
  ),
  PayBillObject(
    name: 'Credit Card Debt',
    icon: Icons.credit_card,
    cost: 1000,
  ),
];
