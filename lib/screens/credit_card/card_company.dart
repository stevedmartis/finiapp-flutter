import 'package:flutter/material.dart';

class CardCompany {
  static CardCompany visa = CardCompany(
    Image.asset(
      'assets/images/cards/visa.png',
      height: 40,
    ),
  );

  static CardCompany americanExpress = const CardCompany(
    Text(
      'AMERICAN \nEXPRESS',
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
    ),
  );

  static CardCompany virgin = CardCompany(
    Image.asset(
      'assets/images/cards/virgin.png',
      height: 40,
    ),
  );

  static CardCompany sbi = CardCompany(
    Image.asset(
      'assets/images/cards/sbi_card.gif',
      height: 35,
    ),
  );

  static CardCompany sbiCard = CardCompany(
    Image.asset(
      'assets/images/cards/sbi.png',
      height: 35,
    ),
  );

  static CardCompany kotak = CardCompany(
    Image.asset(
      'assets/images/cards/kotak_logo.png',
      height: 35,
    ),
  );

  static CardCompany axisBank = CardCompany(
    Image.asset(
      'assets/images/cards/axis_bank_logo.png',
      height: 35,
    ),
  );

  static CardCompany axisBankWhite = CardCompany(
    Image.asset(
      'assets/images/cards/axis_bank_logo.png',
      height: 35,
      color: Colors.white,
    ),
  );

  static CardCompany citiBank = CardCompany(
    Image.asset(
      'assets/images/cards/citibank_logo.png',
      height: 25,
    ),
  );

  static CardCompany hdfc = CardCompany(
    Image.asset(
      'assets/images/cards/hdfc_logo.png',
      height: 25,
    ),
  );

  static CardCompany hsbc = CardCompany(
    Image.asset(
      'assets/images/cards/hsbc_logo.png',
      height: 30,
    ),
  );

  static CardCompany icici = CardCompany(
    Image.asset(
      'assets/images/cards/icici_bank_logo.png',
      height: 25,
    ),
  );

  static CardCompany indusland = CardCompany(
    Image.asset(
      'assets/images/cards/indusland.png',
      height: 15,
    ),
  );

  static CardCompany yesBank = CardCompany(
    Image.asset(
      'assets/images/cards/yes_bank_logo.png',
      height: 35,
    ),
  );

  final Widget widget;

  const CardCompany(this.widget);
}
