import 'package:flutter/material.dart';
import 'package:money_transfer/DetailScreenPages/DetailsPayBill/pay_billl_modal.dart';
import 'package:money_transfer/constants.dart';
import 'package:money_transfer/datamodels/pay_bill_object.dart';
import 'package:money_transfer/Providers/provider_data.dart';
import 'package:provider/provider.dart';

class BillPay extends StatelessWidget {
  static String billPayRoute = 'billPayRoute';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pay Bill'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return PayBillWidgetButton(
              payBillList[index],
              action: () {
                Provider.of<MyProvider>(context, listen: false)
                    .setPayBillObject(payBillList[index]);
                showModalBottomSheet(
                  context: context,
                  builder: (context) => PayBillModal(controller),
                );
              },
            );
          },
          itemCount: payBillList.length,
        ),
      ),
    );
  }
}

class PayBillWidgetButton extends StatelessWidget {
  final PayBillObject payBillObject;
  final VoidCallback action;

  PayBillWidgetButton(this.payBillObject, {required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: componentColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(10),
        onPressed: action,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  payBillObject.name,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Icon(
                payBillObject.icon,
                size: 35.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
