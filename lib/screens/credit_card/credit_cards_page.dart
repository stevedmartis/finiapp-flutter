import 'package:finia_app/screens/credit_card/card_background.dart';
import 'package:finia_app/screens/credit_card/credit_card_slider.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/credit_card/validity.dart';
import 'package:flutter/material.dart';

class CreditCardDemo extends StatefulWidget {
  @override
  _CreditCardDemoState createState() => _CreditCardDemoState();
}

class _CreditCardDemoState extends State<CreditCardDemo> {
  // Inicializa el índice de la tarjeta actual con 0 o el índice de una tarjeta inicial
  int _currentCardIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.3);
  }

  @override
  void dispose() {
    _pageController.dispose(); // No olvides desechar el controlador
    super.dispose();
  }

  void _onCardClicked(int index) {
    // Desplazar el PageView a la tarjeta seleccionada con animación
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isScreenWide = MediaQuery.of(context).size.width >
        600; // Umbral para la pantalla ancha

    // Asegúrate de tener al menos una tarjeta en esta lista
    List<CreditCard> cards = [
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
      ),
      CreditCard(
        cardBackground: SolidColorCardBackground(Colors.orange),
        cardNumber: '9876 5432 1098 7654',
        cardHolderName: 'Jane Doe',
        validity: Validity(validThruMonth: 11, validThruYear: 24),
      ),
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
      ),
    ];

    // Asegúrate de que no hay un índice fuera de rango si la lista está vacía
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Credit Card Slider Demo')),
        body: Center(child: Text('No hay tarjetas disponibles')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Slider Demo'),
      ),
      body: isScreenWide
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CreditCardSlider(
                    cards,
                    pageController: _pageController,
                    initialCard: _currentCardIndex,
                    onCardClicked: _onCardClicked,
                    isVertical: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: CreditCardDetailWidget(
                      key: ValueKey(
                          _currentCardIndex), // Clave única para animación
                      card: cards[_currentCardIndex],
                    ),
                  ),
                ),
              ],
            )
          : CreditCardSlider(
              cards,
              pageController: _pageController,
              initialCard: _currentCardIndex,
              onCardClicked: _onCardClicked,
              isVertical: true,
            ),
    );
  }
}

class CreditCardDetailWidget extends StatelessWidget {
  final CreditCard card;

  const CreditCardDetailWidget({Key? key, required this.card})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Card Number: ${card.cardNumber}'),
            // ... Otros detalles de la tarjeta
          ],
        ),
      ),
    );
  }
}
