import 'package:flutter/foundation.dart';
import 'package:money_transfer/datamodels/pay_bill_object.dart';

class MyProvider extends ChangeNotifier {
  bool registerUsernameError = false;
  bool registerEmailError = false;
  bool registerPwdError = false;
  bool registerRePwdError = false;
  bool twoPwdSame = true;
  String pwdNotSameErrorText = 'Empty password!';
  void checkRegisterUsername(String s) {
    registerUsernameError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkRegisterEmail(String s) {
    registerEmailError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkRegisterPwd(String s) {
    registerPwdError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkRegisterRePwd(String s) {
    registerRePwdError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkTwoPwdSame(String s1, String s2) {
    twoPwdSame = (s1 == s2) ? true : false;
    if (s1.length < 6 && s2.length < 6) {
      pwdNotSameErrorText = 'Password must be 6 characters long!';
      registerPwdError = true;
      registerRePwdError = true;
    } else if (!twoPwdSame) {
      pwdNotSameErrorText = 'Two passwords must be same!';
      registerPwdError = true;
      registerRePwdError = true;
    }
    notifyListeners();
  }

  bool loginEmailError = false;
  bool loginPwdError = false;

  void checkLoginEmail(String s) {
    loginEmailError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkLoginPwd(String s) {
    loginPwdError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  String greetings = 'Welcome Back!';

  bool transferEmailError = false;
  bool transferMoneyError = false;

  void checkTransferEmail(String s) {
    transferEmailError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  String transferMoneyErrorMsg = 'Amount can\'t be empty!';
  void checkTransferMoney(String s) {
    transferMoneyError = (s != '' || s.isNotEmpty) ? false : true;
    if (s == ',' ||
        s == '.' ||
        s.contains(',') ||
        s.contains('.') ||
        s[0] == 0.toString()) {
      transferMoneyError = true;
      transferMoneyErrorMsg = 'Invalid input!';
    }
    notifyListeners();
  }

  void transferEmailInvokeError() {
    transferEmailError = true;
    notifyListeners();
  }

  String topUpPageTitle = '';
  String giftCardUrl = '';
  int selectedGiftCardAmount = 0;

  PayBillObject? _payBillObject;
  void setPayBillObject(PayBillObject p) {
    _payBillObject = p;
  }

  PayBillObject? get payBillObject {
    return _payBillObject;
  }

  bool chgUsernameNameError = false;
  bool chgUsernamePwdError = false;

  void checkChgUsernameName(String s) {
    chgUsernameNameError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkChgUsernamePwd(String s) {
    chgUsernamePwdError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  bool chgPwdCurrentPwdError = false;
  bool chgPwdTwoPwdsSame = false;
  bool checkNewTwoPwds = false;
  String chgPwdText = 'Two passwords must be same';
  void chechChgPwdCurrentPwd(String s) {
    chgPwdCurrentPwdError = (s != '' || s.isNotEmpty) ? false : true;
    notifyListeners();
  }

  void checkChgTwoNewPwds(String s1, String s2) {
    chgPwdTwoPwdsSame = (s1 == s2) ? true : false;
    if (s1.length < 6 && s2.length < 6) {
      checkNewTwoPwds = true;
      chgPwdText = 'Password must be at least 6 characters.';
    } else if (!chgPwdTwoPwdsSame) {
      checkNewTwoPwds = true;
      chgPwdText = 'Two passwords must be same.';
    }
    if (chgPwdTwoPwdsSame && !(s1.length < 6 && s2.length < 6)) {
      checkNewTwoPwds = false;
    }
    notifyListeners();
  }
}
