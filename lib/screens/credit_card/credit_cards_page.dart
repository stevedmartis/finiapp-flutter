import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_slider.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';

import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCardDemo extends StatefulWidget {
  const CreditCardDemo({super.key});
  @override
  CreditCardDemoState createState() => CreditCardDemoState();
}

class CreditCardDemoState extends State<CreditCardDemo> {
  // Inicializa el índice de la tarjeta actual con 0 o el índice de una tarjeta inicial
  int _currentCardIndex = 0;
  late final PageController _pageController;

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
      duration: const Duration(milliseconds: 300),
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
    if (myProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Credit Cards')),
        body: const Center(child: Text('No hay tarjetas disponibles')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: logoAppBarCOLOR,
        title: const Text('Credit Cards'),
      ),
      body: isScreenWide
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CreditCardSlider(
                    myProducts,
                    pageController: _pageController,
                    initialCard: _currentCardIndex,
                    onCardClicked: _onCardClicked,
                    isVertical: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: CreditCardDetailWidget(
                      key: ValueKey(
                          _currentCardIndex), // Clave única para animación
                      card: myProducts[_currentCardIndex],
                    ),
                  ),
                ),
              ],
            )
          : CreditCardSlider(
              myProducts,
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

  const CreditCardDetailWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${card.cardHolderName}'),
              Text('Número: ${card.cardNumber}'),
              Text('Total: ${card.total}'),
              const SizedBox(
                width: 20,
              ),
              Text('Usado: ${card.used}'),
              const SizedBox(
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
