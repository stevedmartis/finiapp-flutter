import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:flutter/material.dart';

class CreditCardHorizontalList extends StatefulWidget {
  final List<CreditCard> cards;

  const CreditCardHorizontalList({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  State<CreditCardHorizontalList> createState() =>
      _CreditCardHorizontalListState();
}

class _CreditCardHorizontalListState extends State<CreditCardHorizontalList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.5, // Ajusta esto según tu necesidad,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => _handleCardTap(context, widget.cards[index]),
                  child: Hero(
                    tag: 'cardsHome-${widget.cards[index].cardNumber}',
                    child: widget.cards[index],
                  ),
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Expanded(
                flex: 0,
                child: GestureDetector(
                  onTap: () => _handleCardTap(context, widget.cards[index]),
                  child: InfoCardsAmounts(
                    fileInfo: widget.cards[index].fileInfo,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _handleCardTap(context, widget.cards[index]),
                  child: TransactionsDashBoardList(
                    transactions: widget.cards[index].transactions,
                  ),
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
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
