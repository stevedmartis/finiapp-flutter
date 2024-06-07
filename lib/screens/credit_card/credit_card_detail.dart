import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/dashboard/components/transactions_list.page.dart';
import 'package:finia_app/services/auth_service.dart';
import 'credit_card_widget.dart';

class CreditCardDetail extends StatefulWidget {
  final CreditCard card;

  const CreditCardDetail({Key? key, required this.card}) : super(key: key);

  @override
  _CreditCardDetailState createState() => _CreditCardDetailState();
}

class _CreditCardDetailState extends State<CreditCardDetail> {
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);
    var tagActual = authService.cardsHero;
    final heroTag = '${tagActual}-${widget.card.cardNumber}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: logoCOLOR2,
        title: Text('Credit Card Detail'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Hero(
              tag: heroTag,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: widget.card,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: defaultPadding),
                  InfoCardsAmounts(
                    fileInfo: widget.card.fileInfo,
                  ),
                  SizedBox(height: defaultPadding),
                  if (Responsive.isMobile(context)) TransactionHistorialPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
