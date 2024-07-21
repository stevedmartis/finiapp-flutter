import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
    await Future.delayed(const Duration(seconds: 2));
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
              backgroundColor: logoAppBarCOLOR,
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
                    context.read<MenuAppController>().controlMenu();
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
              expandedHeight: 280.0,
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
                    /*  Positioned(
                      bottom: 16.0, // Posiciona el contenido más abajo
                      left: 16.0,
                      right: 16.0,
                      child: buildHeaderContent(context, currentTheme),
                    ), */
                    /*  Positioned(
                      bottom: 10.0, // Posiciona el contenido más abajo
                      left: 16.0,
                      right: 16.0,
                      child: GestureDetector(
                        onTap: () => _handleCardTap(context, myProducts[0]),
                        child: Hero(
                          tag: 'cardsHome-${myProducts[0].cardNumber}',
                          child: myProducts[0],
                        ),
                      ),
                    ), */
                    Positioned(
                      bottom: 10.0, // Posiciona el contenido más abajo
                      left: 16.0,
                      right: 16.0,
                      child: SizedBox(
                          height:
                              200.0, // Ajusta el tamaño del contenedor según tus necesidades
                          child: GestureDetector(
                            onTap: () => _handleCardTap(context, myProducts[0]),
                            child: Hero(
                              tag: 'cardsHome-${myProducts[0].toString()}',
                              child: myProducts[0],
                            ),
                          )),
                    ),
                  ],
                ),
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
                title: Opacity(
                  opacity: _showTitle
                      ? 1.0
                      : 0.0, // Hacer el título invisible cuando está expandido
                  child: Text(
                    myProducts[0].cardHolderName!.toUpperCase(),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Mis Lucas',
                          style: TextStyle(
                              fontSize: defaultTitle,
                              fontWeight: FontWeight.bold,
                              color: currentTheme.getSubtitleColor()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildCurrentBalance(currentTheme, myProducts[0].available),
                    buildHeaderContent(context, currentTheme),
                    Text(
                      'Ultima Transacción',
                      style: TextStyle(
                          fontSize: defaultSubTitle,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.getSubtitleColor()),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: GestureDetector(
                        onTap: () => _handleCardTap(context, myProducts[0]),
                        child: TransactionsDashBoardList(
                          transactions: myProducts[0].transactions,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //makeHeaderTitle(),
            /* SliverList(
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
                              /*  GestureDetector(
                                onTap: () => _handleCardTap(
                                    context, myProducts[pageIndex]),
                                child: Hero(
                                  tag:
                                      'cardsHome-${myProducts[pageIndex].cardNumber}',
                                  child: myProducts[pageIndex],
                                ),
                              ), */

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
 */
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding),
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
    Provider.of<ThemeProvider>(context, listen: false).changePageDetail(true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetail(card: card),
      ),
    ).then((_) {
      Provider.of<ThemeProvider>(context, listen: false)
          .changePageDetail(false);
    });
  }

  Widget makeHeaderTitle() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderTitleDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
          color: Colors.white,
          child: const Center(
            child: Text(
              'Título Personalizado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentBalance(ThemeProvider themeProvider, double available) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _handleCardTap(context, myProducts[0]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                gradient: themeProvider.getGradientCard(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: logoCOLOR1,
                        size: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formatCurrency(available),
                        style: TextStyle(
                          color: themeProvider.getSubtitleColor(),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: logoCOLOR1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildHeaderContent(BuildContext context, ThemeProvider themeProvider) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Text(
          'Plata Total:',
          style: TextStyle(
            color: Colors.white70,
            fontSize: defaultSubTitle,
          ),
        ),
        SizedBox(height: 10), */
        /*  Text(
          formatCurrency(1842081),
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20), */
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
      gradient: themeProvider.getGradientCard(),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: themeProvider.getSubtitleColor(),
                  ),
                ),
                Text(
                  formatCurrency(amount),
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.getSubtitleColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    ),
  );
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
