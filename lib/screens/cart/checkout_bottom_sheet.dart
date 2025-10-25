import 'package:flutter/material.dart';

import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_text.dart';
import '../order_failed_dialog.dart';

class CheckoutBottomSheet extends StatefulWidget {
  final double totalPrice; // ✅ إضافة بارامتر السعر

  const CheckoutBottomSheet({Key? key, required this.totalPrice}) : super(key: key);

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: new Wrap(
        children: <Widget>[
          Row(
            children: [
              AppText(
                text: "Checkout",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 25,
                  ))
            ],
          ),
          SizedBox(
            height: 45,
          ),
          getDivider(),
          checkoutRow("Delivery", trailingText: "Select Method"),
          getDivider(),
          checkoutRow(
            "Payment",
            trailingWidget: getPaymentIcon(),
          ),
          getDivider(),
          checkoutRow("Promo Code", trailingText: "Pick discount"),
          getDivider(),
          // ✅ التصحيح: استخدام السعر الديناميكي
          checkoutRow("Total Cost", trailingText: "\$${widget.totalPrice.toStringAsFixed(2)}"),
          getDivider(),
          SizedBox(
            height: 30,
          ),
          termsAndConditionText(),
          SizedBox(
            height: 20,
          ),
          AppButton(
            label: "Place Order",
            fontWeight: FontWeight.w600,
            onPressed: onPlaceOrderClicked,
          ),
        ],
      ),
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget getPaymentIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/icons/card_icon.png"),
        ),
      ),
    );
  }

  Widget termsAndConditionText() {
    return RichText(
      text: new TextSpan(
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 15,
          ),
          children: [
            new TextSpan(
              text: "By placing an order you agree to our",
            ),
            new TextSpan(
              text: " Terms",
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            new TextSpan(text: " And"),
            new TextSpan(
              text: " Conditions",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
    );
  }

  Widget checkoutRow(String label,
      {String? trailingText, Widget? trailingWidget}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        children: [
          AppText(
            text: label,
            fontSize: 18,
            color: Color(0xFF7C7C7C),
            fontWeight: FontWeight.w600,
          ),
          Spacer(),
          trailingText == null
              ? (trailingWidget ?? Container())
              : AppText(
            text: trailingText,
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
          )
        ],
      ),
    );
  }

  void onPlaceOrderClicked() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderFailedDialog(); // ✅ التصحيح الإملائي
      },
    );
  }
}