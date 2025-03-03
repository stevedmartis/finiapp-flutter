import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/dashboard/components/transactions_list.page.dart';
import 'package:finia_app/services/auth_service.dart';
import 'credit_card_widget.dart';

class CreditCardDetail extends StatefulWidget {
  final CreditCard card;

  const CreditCardDetail({super.key, required this.card});

  @override
  CreditCardDetailState createState() => CreditCardDetailState();
}

class CreditCardDetailState extends State<CreditCardDetail> {
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);
    var tagActual = authService.cardsHero;
    final heroTag = '$tagActual-${widget.card.cardNumber}';
    final currentTheme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: logoAppBarCOLOR,
        title: Text('Cuenta ${widget.card.cardHolderName}'),
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
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildCurrentBalance(currentTheme, widget.card.available),
                  const SizedBox(height: defaultPadding),
                  InfoCardsAmounts(
                    fileInfo: widget.card.fileInfo,
                  ),
                  if (Responsive.isMobile(context))
                    const TransactionHistorialPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBalance(ThemeProvider themeProvider, double available) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: themeProvider.getGradientCard(),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: logoCOLOR1,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatCurrency(available),
                      style: TextStyle(
                        color: themeProvider.getSubtitleColor(),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: logoCOLOR1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
