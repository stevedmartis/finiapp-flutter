import 'package:finia_app/constants.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/storage_details.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'credit_card_widget.dart';

class CreditCardDetail extends StatefulWidget {
  final CreditCard card;

  const CreditCardDetail({Key? key, required this.card}) : super(key: key);

  @override
  State<CreditCardDetail> createState() => _CreditCardDetailState();
}

class _CreditCardDetailState extends State<CreditCardDetail> {
  @override
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);

    var tagActual = authService.cardsHero;
    final heroTag = '${tagActual}-${widget.card.cardNumber}';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contenido de la página debajo de la tarjeta de crédito
          Hero(
              tag: heroTag,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 80.0, left: 30, right: 30, bottom: defaultPadding),
                  child: widget.card)),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              primary: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //WebViewWidget(controller: _controller),
                    MyFiles(),
                    if (Responsive.isMobile(context)) StorageDetails(),
                    // Agrega aquí los widgets de contenido debajo de la tarjeta
                  ],
                ),
              ),
            ),
          ),
          // Tarjeta de crédito
        ],
      ),
    );
  }
}
