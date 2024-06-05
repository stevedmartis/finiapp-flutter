import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
              backgroundColor: logoCOLOR2,
              leading: Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.read<MenuAppController>().controlMenu();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_2_outlined, color: Colors.black),
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
              expandedHeight: 280.0, // Incrementado para más espacio
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Title',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Button'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: myProducts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, myProducts[index]),
                            child: Hero(
                              tag: 'cardsHome-${myProducts[index].cardNumber}',
                              child: myProducts[index],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _handleCardTap(context, myProducts[index]),
                          child: InfoCardsAmounts(
                            fileInfo: myProducts[index].fileInfo,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, myProducts[index]),
                            child: TransactionsDashBoardList(
                              transactions: myProducts[index].transactions,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ),

              SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BudgetedExpensesChart(), // Implementación del widget BudgetedExpensesChart
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

class BudgetedExpensesChart extends StatefulWidget {
  @override
  _BudgetedExpensesChartState createState() => _BudgetedExpensesChartState();
}

class _BudgetedExpensesChartState extends State<BudgetedExpensesChart> {
  late List<BudgetItem> budgetItems;

  @override
  void initState() {
    super.initState();
    budgetItems = getBudgetItems();
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos la altura de la lista basada en la cantidad de elementos
    double listHeight = budgetItems.length *
        72.0; // Asumiendo que cada ListTile tiene una altura de 72 pixels
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 300,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CircularSeries>[
                PieSeries<BudgetItem, String>(
                  dataSource: budgetItems,
                  xValueMapper: (BudgetItem data, _) => data.category,
                  yValueMapper: (BudgetItem data, _) => data.spent,
                  pointColorMapper: (BudgetItem data, _) =>
                      getColorForCategory(data.category),
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                  name: 'Gastos',
                )
              ],
            ),
          ),
          // Usamos un tamaño fijo para la lista basado en la cantidad de elementos
          Container(
            height:
                listHeight, // Altura dinámica basada en la cantidad de elementos
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: budgetItems.length,
              itemBuilder: (context, index) {
                final item = budgetItems[index];
                double spentPercentage = (item.spent / item.budget) * 100;
                return ListTile(
                  leading: Icon(getIconForCategory(item.category),
                      color: getColorForCategory(item.category)),
                  title: Text(item.category,
                      style:
                          TextStyle(color: themeProvider.getSubtitleColor())),
                  subtitle: Text(
                      'Gastado: \$${item.spent} de \$${item.budget}',
                      style: TextStyle(color: Colors.grey[400])),
                  trailing: CircularProgressIndicator(
                    value: spentPercentage / 100,
                    backgroundColor:
                        spentPercentage > 100 ? Colors.red : Colors.green,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'Alimentación':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.train;
      case 'Salud':
        return Icons.favorite;
      case 'Entretenimiento':
        return Icons.sports_esports;
      default:
        return Icons.category;
    }
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case 'Alimentación':
        return Colors.yellow;
      case 'Transporte':
        return Colors.green;
      case 'Salud':
        return Colors.orange;
      case 'Entretenimiento':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<BudgetItem> getBudgetItems() {
    return [
      BudgetItem(category: 'Alimentación', budget: 200, spent: 150),
      BudgetItem(category: 'Transporte', budget: 100, spent: 75),
      BudgetItem(category: 'Salud', budget: 300, spent: 250),
      BudgetItem(category: 'Entretenimiento', budget: 120, spent: 90),
    ];
  }
}

class BudgetItem {
  final String category;
  final double budget;
  final double spent;

  BudgetItem(
      {required this.category, required this.budget, required this.spent});
}