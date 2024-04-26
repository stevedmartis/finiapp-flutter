import 'package:finia_app/screens/credit_card/card_background.dart';
import 'package:finia_app/screens/credit_card/card_company.dart';
import 'package:finia_app/screens/credit_card/credit_card_slider.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/credit_card/validity.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCardDemo extends StatefulWidget {
  @override
  _CreditCardDemoState createState() => _CreditCardDemoState();
}

class _CreditCardDemoState extends State<CreditCardDemo> {
  // Inicializa el índice de la tarjeta actual con 0 o el índice de una tarjeta inicial
  int _currentCardIndex = 0;
  late final PageController _pageController;

  List<CreditCard> cards = [
    CreditCard(
        cardBackground: GradientCardBackground(
          LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        cardNumber: '2345 5678 4565 8765',
        cardHolderName: 'John Doe',
        validity: Validity(validThruMonth: 12, validThruYear: 25),
        total: 250000,
        used: 200000,
        available: 10,
        delay: true,
        company: CardCompany(Image.asset(
          'assets/images/cards/visa.jpeg',
          height: 40,
        ))),
    CreditCard(
        cardBackground: SolidColorCardBackground(Colors.orange),
        cardNumber: '3456 7896 7896 5678',
        cardHolderName: 'Jane Doe',
        validity: Validity(validThruMonth: 11, validThruYear: 24),
        total: 150000,
        used: 300000,
        available: 5,
        delay: true,
        company: CardCompany(Image.asset(
          'assets/images/cards/mastercard.png',
          height: 40,
        ))),
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
        total: 40000,
        used: 18000,
        available: 2,
        delay: true,
        company: CardCompany(Image.asset(
          'assets/images/cards/mastercard.png',
          height: 40,
        ))),
  ];

  @override
  void initState() {
    int initialIndex = Provider.of<AuthService>(context, listen: false).index;

    super.initState();
    _pageController =
        PageController(initialPage: initialIndex, viewportFraction: 0.3);

    _currentCardIndex = initialIndex;
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

    // Asegúrate de que no hay un índice fuera de rango si la lista está vacía
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Credit Cards')),
        body: Center(child: Text('No hay tarjetas disponibles')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Cards'),
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
          : Stack(
              children: [
                CreditCardSlider(
                  cards,
                  pageController: _pageController,
                  initialCard: _currentCardIndex,
                  onCardClicked: _onCardClicked,
                  isVertical: true,
                ),
/*                 Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CreditCardDetailWidget(
                    card: cards[_currentCardIndex],
                  ),
                ), */
              ],
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
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${card.cardHolderName}'),
              Text('Número: ${card.cardNumber}'),
              Text('Total: ${card.total}'),
              SizedBox(
                width: 20,
              ),
              Text('Usado: ${card.used}'),
              SizedBox(
                width: 20,
              ),
              Text('Disponible: ${card.available}'),

              // ... Otros detalles de la tarjeta
            ],
          ),
        ),
      ),
    );
  }
}
