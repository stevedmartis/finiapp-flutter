import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:finia_app/screens/dashboard/floid_widget.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedScrollView extends StatefulWidget {
  @override
  State<AdvancedScrollView> createState() => _AdvancedScrollViewState();
}

class _AdvancedScrollViewState extends State<AdvancedScrollView> {
  late ScrollController _scrollController;
  late MenuAppController menuAppController;

  final PageController _pageController = PageController(viewportFraction: 0.85);
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
    await Future.delayed(Duration(seconds: 2));
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

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(
        'https://admin.floid.app/finia_app/widget/80c2083bbc755fa3548e55c627c78006?sandbox');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              leadingWidth: 60,
              backgroundColor: logoAppBarCOLOR,
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
                      'Mis Cuentas',
                      style: TextStyle(
                          fontSize: defaultTitle,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.getSubtitleColor()),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        (!kIsWeb)
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FloidWidgetScreen()))
                            : _launchUrl();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height:
                    MediaQuery.of(context).size.height * 0.235, // Full height
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: myProducts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _handleCardTap(context, myProducts[index]),
                          child: Hero(
                            tag: 'cardsHome-${myProducts[index].cardNumber}',
                            child: myProducts[index],
                          ),
                        ),
                      ],
                    );
                  },
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
                    Text(
                      'Ultima Transacción',
                      style: TextStyle(
                          fontSize: defaultSubTitle,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.getSubtitleColor()),
                    ),
                    SizedBox(height: 10),
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

  SliverList makeListRecomendations(bool loading) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height, // Full height
            child: PageView.builder(
              controller: _pageController,
              itemCount: myProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.metrics.axis == Axis.vertical) {
                        _scrollController.jumpTo(
                          _scrollController.position.pixels +
                              scrollNotification.scrollDelta!,
                        );
                      }
                      return false; // Permite que otras notificaciones continúen propagándose
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, myProducts[index]),
                            child: Hero(
                              tag: 'cardsHome-${myProducts[index].cardNumber}',
                              child: myProducts[index],
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, myProducts[index]),
                            child: InfoCardsAmounts(
                              fileInfo: myProducts[index].fileInfo,
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, myProducts[index]),
                            child: TransactionsDashBoardList(
                              transactions: myProducts[index].transactions,
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, myProducts[index]),
                            child: BudgetedExpensesChart(),
                          ),
                          SizedBox(
                              height: 16), // Agrega espacio adicional al final
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        childCount: 1, // Solo un PageView en la lista
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
              fontSize: 16,
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
