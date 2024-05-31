import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCardHorizontalList extends StatelessWidget {
  final List<CreditCard> cards;

  const CreditCardHorizontalList({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final PageController _pageController =
        PageController(viewportFraction: 0.85);

    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      height: MediaQuery.of(context).size.height * 0.5,
      child: PageView.builder(
        controller: _pageController,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => _handleCardTap(context, cards[index]),
                child: Hero(
                  tag: 'cardsHome-${cards[index].cardNumber}',
                  child: cards[index],
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _handleCardTap(context, cards[index]),
                child: InfoCardsAmounts(
                  fileInfo: cards[index].fileInfo,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _handleCardTap(context, cards[index]),
                child: TransactionsDashBoardList(
                  transactions: cards[index].transactions,
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  void _handleCardTap(BuildContext context, CreditCard card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetail(card: card),
      ),
    );
  }
}
