import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_transfer/DetailScreenPages/DetailsPayBill/bill_pay_screen.dart';
import 'package:money_transfer/DetailScreenPages/SettingScreens/change_password.dart';
import 'package:money_transfer/DetailScreenPages/SettingScreens/change_username.dart';
import 'package:money_transfer/Screens/details_screen.dart';
import 'package:money_transfer/DetailScreenPages/DetailsTopUp/gift_card_buy_screen.dart';
import 'package:money_transfer/Screens/home.dart';
import 'package:money_transfer/Screens/loan_screen.dart';
import 'package:money_transfer/Screens/login_screen.dart';
import 'package:money_transfer/Screens/register_screen.dart';
import 'package:money_transfer/DetailScreenPages/DetailsTopUp/top_up_page.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.get('email');
  runApp(MyApp(email == null ? '/' : DetailsScreen.detailsScreenRoute));
}

class MyApp extends StatelessWidget {
  String initialRoute;

  MyApp(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyProvider>(create: (context) => MyProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mainColor,
          appBarTheme: AppBarTheme(
            backgroundColor: mainColor,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: mainColor,
            selectedIconTheme: IconThemeData(
              color: textColor,
            ),
            selectedItemColor: textColor,
          ),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: textColor,
                displayColor: textColor,
                fontFamily: 'Poppin',
              ),
        ),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => HomeScreen(),
          LoginScreen.loginScreenRoute: (context) => LoginScreen(),
          RegisterScreen.registerScreenRoute: (context) => RegisterScreen(),
          DetailsScreen.detailsScreenRoute: (context) => DetailsScreen(),
          TopUpPage.topUpPageRoute: (context) => TopUpPage(),
          GiftCardBuy.giftCardBuyRoute: (context) => GiftCardBuy(),
          BillPay.billPayRoute: (context) => BillPay(),
          LoanScreen.loanScreenRoute: (context) => LoanScreen(),
          ChangePasswordScreen.changePasswordScreenRoute: (context) =>
              ChangePasswordScreen(),
          ChangeUserNameScreen.changeUserNameScreenRoute: (context) =>
              ChangeUserNameScreen(),
        },
      ),
    );
  }
}
