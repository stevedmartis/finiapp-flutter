import 'package:flutter/material.dart';

class CardNetworkType {
  static CardNetworkType visa = CardNetworkType(
    Image.asset(
      'images/visa.jpeg',
      height: 35,
    ),
  );

  static CardNetworkType mastercard = CardNetworkType(
    Image.asset(
      'images/mastercard.png',
      height: 40,
    ),
  );

  static CardNetworkType visaBasic = CardNetworkType(
    Image.asset(
      'images/visa_basic.png',
      height: 20,
    ),
  );

  static CardNetworkType rupay = CardNetworkType(
    Image.asset(
      'images/rupay_logo.png',
      height: 40,
    ),
  );

  static CardNetworkType americanExpress = CardNetworkType(Image.asset(
    'images/amex_logo.png',
    height: 50,
  ));

  static CardNetworkType discover = CardNetworkType(Image.asset(
    'images/discover.png',
    height: 50,
  ));

  static CardNetworkType unionPay = CardNetworkType(Image.asset(
    'images/union_pay.png',
    height: 50,
  ));

  final Widget widget;

  const CardNetworkType(this.widget);
}
