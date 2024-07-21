import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/credit_card_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';

class SearchPrincipalPage extends StatefulWidget {
  @override
  SearchPrincipalPageState createState() => SearchPrincipalPageState();

  const SearchPrincipalPage({super.key});
}

class SearchPrincipalPageState extends State<SearchPrincipalPage> {
  late ScrollController _scrollController;
  late MenuAppController menuAppController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showTitle =
              _scrollController.hasClients && _scrollController.offset > 150;
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    menuAppController = Provider.of<MenuAppController>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  String formatCurrency(double amount) {
    final NumberFormat format =
        NumberFormat.currency(locale: 'es_CL', symbol: '');
    String formatted = format.format(amount);
    formatted = formatted
        .replaceAll('\$', '')
        .replaceAll(',', ''); // Eliminar símbolo y separador de miles
    return '\$${formatted.substring(0, formatted.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: currentTheme.getBackgroundColor(),
      body: RefreshIndicator(
        color: currentTheme.getBackgroundColor(),
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              leadingWidth: 60,
              backgroundColor: logoCOLOR2,
              leading: Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.read<MenuAppController>().controlMenu();
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        'assets/images/profile_pic.png'), // Ruta a tu imagen
                    backgroundColor: Colors
                        .transparent, // Para asegurar que no haya un color de fondo
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Navegar a la página de notificaciones
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 20,
                      top: 10,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                )
              ],
              stretch: true,
              expandedHeight: 280.0, // Incrementado para más espacio
              collapsedHeight: 70,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -2.0),
                          end: Alignment.bottomCenter,
                          colors: [
                            logoCOLOR1,
                            logoCOLOR2,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16.0, // Posiciona el contenido más abajo
                      left: 16.0,
                      right: 16.0,
                      child: buildHeaderContent(context, currentTheme),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ),
            makeListRecomendations(),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderContent(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Total:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            formatCurrency(1842081),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildIndicator(
                icon: Icons.arrow_upward,
                title: 'Ingresado',
                amount: 12000,
                context: context,
                isPositive: true,
                themeProvider: themeProvider,
              ),
              const SizedBox(width: 16),
              buildIndicator(
                icon: Icons.arrow_downward,
                title: 'Gastado',
                amount: 6000,
                context: context,
                isPositive: false,
                themeProvider: themeProvider,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIndicator({
    required IconData icon,
    required String title,
    required double amount,
    required BuildContext context,
    required bool isPositive,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isPositive ? Colors.green : Colors.red,
                size: 30,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    formatCurrency(amount),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  SliverList makeListRecomendations() {
    final currentTheme = Provider.of<ThemeProvider>(context);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: currentTheme.getBackgroundColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0), // Reducido el padding vertical
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 4.0), // Reducido el padding inferior
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mis Productos',
                          style: TextStyle(
                            fontSize: 20,
                            color: currentTheme.getTitleColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height:
                          4.0), // Añadido un pequeño espacio entre el título y la lista
                  CreditCardHorizontalList(cards: myProducts),
                  BudgetedExpensesChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
