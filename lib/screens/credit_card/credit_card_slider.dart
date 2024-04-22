import 'dart:math';
import 'package:flutter/material.dart';
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
    this.percentOfUpperCard = 0.35,
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

  @override
  void initState() {
    super.initState();

    _currentPageIndex = widget.initialCard;
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
    if (widget.repeatCards == RepeatCards.down ||
        widget.repeatCards == RepeatCards.bothDirection) {
      return PageView.builder(
        controller: _pageController,
        scrollDirection:
            widget.isVertical ? Axis.vertical : Axis.horizontal, // Cambio aquí
        itemBuilder: (context, index) =>
            _builder(index, widget.creditCards.length),
      );
    }
    return PageView.builder(
      controller: widget.pageController,
      scrollDirection:
          widget.isVertical ? Axis.vertical : Axis.horizontal, // Cambio aquí
      itemCount: widget.creditCards.length,
      itemBuilder: (context, index) =>
          _builder(index, widget.creditCards.length),
    );
  }

  Widget _builder(int index, int length) {
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
          widget.onCardClicked(index % length);
        },
        child: widget.creditCards[index % length],
      ),
    );
  }
}
