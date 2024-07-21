import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:flutter/material.dart';

class CreditCardHorizontalList extends StatelessWidget {
  final List<CreditCard> cards;

  const CreditCardHorizontalList({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final PageController _pageController =
        PageController(viewportFraction: 0.85);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: PageView.builder(
        controller: _pageController,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ListView(
              physics:
                  const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento en ListView
              children: [
                GestureDetector(
                  onTap: () => _handleCardTap(context, cards[index]),
                  child: Hero(
                    tag: 'cardsHome-${cards[index].cardNumber}',
                    child: cards[index],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _handleCardTap(context, cards[index]),
                  child: InfoCardsAmounts(
                    fileInfo: cards[index].fileInfo,
                  ),
                ),
                GestureDetector(
                  onTap: () => _handleCardTap(context, cards[index]),
                  child: TransactionsDashBoardList(
                    transactions: cards[index].transactions,
                  ),
                ),
              ],
            ),
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
