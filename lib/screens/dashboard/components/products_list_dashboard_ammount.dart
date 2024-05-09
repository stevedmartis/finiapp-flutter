import 'package:finia_app/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';

class ProductsListAmmountsDashboard extends StatefulWidget {
  final List<CreditCard> cards;

  const ProductsListAmmountsDashboard({Key? key, required this.cards})
      : super(key: key);

  @override
  _ProductsListAmmountsDashboardState createState() =>
      _ProductsListAmmountsDashboardState();
}

class _ProductsListAmmountsDashboardState
    extends State<ProductsListAmmountsDashboard> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPageIndex != next) {
        setState(() {
          _currentPageIndex = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<CloudStorageInfo> getFilesForCard(int index) {
    switch (index) {
      case 0:
        return [demoMyFiles[0], demoMyFiles[1]]; // For card 1
      case 1:
        return [demoMyFiles[2]]; // For card 2
      case 2:
        return [demoMyFiles[3], demoMyFiles[4]]; // For card 3
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: 'cardsHome-${widget.cards[index].cardNumber}',
                child: widget.cards[index],
              );
            },
          ),
        ),
        // Expanded(flex: 1, child: InfoCardsAmounts(controller: _pageController, cards: widget.cards,)),
      ],
    );
  }
}
