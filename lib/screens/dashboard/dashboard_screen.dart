import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/credit_card/card_background.dart';
import 'package:finia_app/screens/credit_card/card_company.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/credit_card/validity.dart';
import 'package:finia_app/screens/dashboard/components/credit_card_horizontal.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/floid_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(
        'https://admin.floid.app/finia_app/widget/80c2083bbc755fa3548e55c627c78006?sandbox');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CreditCard> cards = [
      CreditCard(
          cardBackground: GradientCardBackground(
            LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          cardNumber: '2345 5678 4565 8765',
          cardHolderName: 'John Doe',
          validity: Validity(validThruMonth: 12, validThruYear: 25),
          total: 250000,
          used: 200000,
          available: 10,
          delay: true,
          company: CardCompany(Image.asset(
            'assets/images/cards/visa.jpeg',
            height: 40,
          ))),
      CreditCard(
          cardBackground: SolidColorCardBackground(Colors.orange),
          cardNumber: '3456 7896 7896 5678',
          cardHolderName: 'Jane Doe',
          validity: Validity(validThruMonth: 11, validThruYear: 24),
          total: 150000,
          used: 300000,
          available: 5,
          delay: true,
          company: CardCompany(Image.asset(
            'assets/images/cards/mastercard.png',
            height: 40,
          ))),
      CreditCard(
          cardBackground: GradientCardBackground(
            LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          cardNumber: '1234 5678 9012 3456',
          cardHolderName: 'John Doe',
          validity: Validity(validThruMonth: 12, validThruYear: 25),
          total: 40000,
          used: 18000,
          available: 2,
          delay: true,
          company: CardCompany(Image.asset(
            'assets/images/cards/mastercard.png',
            height: 40,
          ))),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mis Tarjetas",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    (!kIsWeb)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FloidWidgetScreen()))
                        : _launchUrl();
                  },
                  icon: Icon(Icons.add),
                  label: Text("Agregar"),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: CreditCardHorizontalList(cards: cards),
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // WebViewWidget(controller: _controller),
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      // RecentFiles(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
