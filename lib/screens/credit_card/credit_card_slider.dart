import 'dart:math';

import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'credit_card_widget.dart';

typedef void OnCardClicked(int index);

enum RepeatCards { down, bothDirection, none }

class CreditCardSlider extends StatefulWidget {
  final List<CreditCard> creditCards;
  final double percentOfUpperCard;
  final OnCardClicked onCardClicked;
  final RepeatCards repeatCards;
  final int initialCard;
  final bool isVertical; // Nuevo parámetro
  final PageController pageController;

  CreditCardSlider(
    this.creditCards, {
    this.onCardClicked = _defaultOnCardClicked,
    this.repeatCards = RepeatCards.none,
    this.initialCard = 0,
    this.percentOfUpperCard = 0.90,
    this.isVertical = true,
    required this.pageController, // Valor predeterminado vertical
  }) {
    assert(initialCard >= 0);
    assert(initialCard < creditCards.length);
    assert(percentOfUpperCard >= 0);
    assert(percentOfUpperCard <= pi / 2);
  }

  @override
  _CreditCardSliderState createState() => _CreditCardSliderState();

  static void _defaultOnCardClicked(int index) {
    // Default implementation
  }
}

class _CreditCardSliderState extends State<CreditCardSlider> {
  late PageController _pageController;
  late int _currentPageIndex;
  int? _lastTappedIndex;
  int _tapCount = 0;
  @override
  void initState() {
    super.initState();

    _currentPageIndex = widget.initialCard;
    print(widget.creditCards[_currentPageIndex].cardNumber);
    // Inicializa con el valor de initialCard
    _pageController = widget.pageController;
    _pageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    int currentPage = _pageController.page!.round();
    if (_currentPageIndex != currentPage) {
      _currentPageIndex = currentPage; // Actualiza el índice actual
      widget
          .onCardClicked(currentPage); // Llama al callback con el nuevo índice
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange); // Remueve el listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => {
        Provider.of<AuthService>(context, listen: false).cardsHero = 'cardsHome'
      },
      child: PageView.builder(
        controller: widget.pageController,
        scrollDirection:
            widget.isVertical ? Axis.vertical : Axis.horizontal, // Cambio aquí
        itemCount: widget.creditCards.length,
        itemBuilder: (context, index) =>
            _builder(index, widget.creditCards.length, context),
      ),
    );
  }

  Widget _builder(int index, int length, context) {
    final card = widget.creditCards[index % length];
    return AnimatedBuilder(
      animation: widget.pageController,
      builder: (context, child) {
        double value = 1.0;

        int mIndex = index % length;
        int mInitialPage = widget.initialCard % length;

        if (widget.pageController.position.haveDimensions) {
          value = widget.pageController.page! - index;

          if (value >= 0) {
            double _lowerLimit = widget.percentOfUpperCard;
            double _upperLimit = pi / 2;

            value = (_upperLimit - (value.abs() * (_upperLimit - _lowerLimit)))
                .clamp(_lowerLimit, _upperLimit);
            value = _upperLimit - value;
            value *= -1;
          }
        } else {
          if (mIndex == mInitialPage) {
            value = 0;
          } else if (mInitialPage == 0 || mIndex == mInitialPage - 1) {
            value = -(pi / 2 - widget.percentOfUpperCard);
          } else if (mIndex == mInitialPage + 1) {
            value = -1;
          } else {
            value = pi / 2;
          }
        }

        return Center(
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(value),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (_currentPageIndex == index) {
            // Check if the tapped card is the current one
            if (_lastTappedIndex != index) {
              // If it's the first tap or a different card was previously tapped
              _lastTappedIndex = index;
              _tapCount = 1;
            } else {
              // If the same card was tapped consecutively
              _tapCount++;
            }

            if (_tapCount == 1) {
              // Check if it's the second consecutive tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreditCardDetail(
                    card: card,
                  ),
                ),
              ).then((value) => {
                    // Reset tap count when returning from the detail page
                    _tapCount = 0,
                    _lastTappedIndex = null,
                  });
            }
          } else {
            // Optionally, animate to the tapped card if it's not the current one
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            _lastTappedIndex = null; // Reset the last tapped index
            _tapCount = 0; // Reset the tap count
          }
        },
        child: Hero(
            tag: 'cardsMenu-${widget.creditCards[index % length].cardNumber}',
            child: widget.creditCards[index % length]),
      ),
    );
  }
}
