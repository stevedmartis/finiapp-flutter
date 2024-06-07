import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String formatCurrency(double amount) {
  final NumberFormat format =
      NumberFormat.currency(locale: 'es_CL', symbol: '');
  String formatted = format.format(amount);
  formatted = formatted
      .replaceAll('\$', '')
      .replaceAll(',', ''); // Eliminar símbolo y separador de miles
  return '\$${formatted.substring(0, formatted.length - 3)}';
}

class AdvancedScrollView2 extends StatefulWidget {
  @override
  State<AdvancedScrollView2> createState() => _AdvancedScrollViewState();
}

class _AdvancedScrollViewState extends State<AdvancedScrollView2> {
  late ScrollController _scrollController;
  late MenuAppController menuAppController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool _showTitle = false;
  bool _enableVerticalScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showTitle =
              _scrollController.hasClients && _scrollController.offset > 150;
          _enableVerticalScroll = _scrollController.hasClients &&
              _scrollController.offset >= (280 - 70);
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
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        color: logoCOLOR1,
        backgroundColor: currentTheme.getBackgroundColor(),
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              leadingWidth: 60,
              backgroundColor: logoCOLOR2,
              leading: Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.read<MenuAppController>().controlMenu();
                  },
                  child: CircleAvatar(
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
                    context.read<MenuAppController>().controlMenu();
                    // Navegar a la página de notificaciones
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 20,
                      top: 10,
                    ),
                    child: Row(
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
              expandedHeight: 280.0,
              collapsedHeight: 70,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
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
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Mi Cuenta',
                      style: TextStyle(
                          fontSize: defaultTitle, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            //makeHeaderTitle(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    height: MediaQuery.of(context).size.width *
                        1.3, // Ajusta la altura según tu diseño
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, pageIndex) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _handleCardTap(
                                    context, myProducts[pageIndex]),
                                child: Hero(
                                  tag:
                                      'cardsHome-${myProducts[pageIndex].cardNumber}',
                                  child: myProducts[pageIndex],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child: TransactionsDashBoardList(
                                  transactions:
                                      myProducts[pageIndex].transactions,
                                ),
                              ),
                              // BudgetedExpensesChart(),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: 1,
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(defaultPadding),
                    height: MediaQuery.of(context).size.width *
                        2, // Ajusta la altura según tu diseño
                    child: BudgetedExpensesChart(),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
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

  Widget makeHeaderTitle() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderTitleDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              'Título Personalizado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
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
          Text(
            'Balance Total:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: defaultSubTitle,
            ),
          ),
          SizedBox(height: 10),
          Text(
            formatCurrency(1842081),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
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
              SizedBox(width: 16),
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
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
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
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    formatCurrency(amount),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class SliverCustomHeaderTitleDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverCustomHeaderTitleDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverCustomHeaderTitleDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
