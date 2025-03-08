import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'package:finia_app/screens/credit_card/account_cards_widget.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/custom_nav_bar.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:finia_app/screens/dashboard/components/transactions_dashboard.dart';
import 'package:finia_app/screens/dashboard/transactions/transaction_add_form.dart';
import 'package:finia_app/screens/dashboard/transactions/transaction_dash_list.dart';
import 'package:finia_app/screens/login/add_accouts_explain_page.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DashBoardHomeScreen extends StatefulWidget {
  const DashBoardHomeScreen({super.key});
  @override
  State<DashBoardHomeScreen> createState() => DashBoardHomeScreenState();
}

class DashBoardHomeScreenState extends State<DashBoardHomeScreen> {
  late ScrollController _scrollController;
  late MenuAppController menuAppController;

  String? _currentAccountId;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          showTitle =
              _scrollController.hasClients && _scrollController.offset > 150;
        });
      });

    _pageController.addListener(() {
      final int currentPage = _pageController.page?.round() ?? 0;
      final accountsProvider =
          Provider.of<AccountsProvider>(context, listen: false);

      if (accountsProvider.accounts.isNotEmpty) {
        accountsProvider
            .setCurrentAccountId(accountsProvider.accounts[currentPage].id);
      }
    });

    // ✅ Establecer el valor inicial después de construir el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountsProvider =
          Provider.of<AccountsProvider>(context, listen: false);

      if (accountsProvider.accounts.isNotEmpty) {
        setState(() {
          _currentAccountId = accountsProvider.accounts[0].id;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    menuAppController = Provider.of<MenuAppController>(context);

    final accountsProvider =
        Provider.of<AccountsProvider>(context, listen: false);

    if (_currentAccountId == null && accountsProvider.accounts.isNotEmpty) {
      setState(() {
        _currentAccountId = accountsProvider.accounts.first.id;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  String formatAbrevCurrency(double amount) {
    if (amount.abs() >= 1e9) {
      // Si es mayor a mil millones → Billones (B)
      return '\$${(amount / 1e9).toStringAsFixed(1)}B';
    } else if (amount.abs() >= 1e6) {
      // Si es mayor a un millón → Millones (M)
      return '\$${(amount / 1e6).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1e3) {
      // Si es mayor a mil → Miles (K)
      return '\$${(amount / 1e3).toStringAsFixed(1)}K';
    } else {
      // ✅ Si es menor a mil → Formato tradicional
      final NumberFormat format =
          NumberFormat.currency(locale: 'es_CL', symbol: '');
      String formatted = format.format(amount);
      formatted = formatted
          .replaceAll('\$', '')
          .replaceAll(',', ''); // Eliminar símbolo y separador de miles

      // ✅ Mostrar sin decimales
      return '\$${formatted.substring(0, formatted.length - 3)}';
    }
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(
        'https://admin.floid.app/finia_app/widget/80c2083bbc755fa3548e55c627c78006?sandbox');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String getFirstWord(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "";
    return fullName.split(" ").first; // Divide y toma la primera palabra
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthService>(context);
    final currentAccountId =
        Provider.of<AccountsProvider>(context, listen: true).currentAccountId;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        onTransactionPressed: () {
          if (currentAccountId != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const AddTransactionBottomSheet(),
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddAccountScreen()));
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              leadingWidth: 200,
              backgroundColor: logoAppBarCOLOR,
              leading: Row(
                children: [
                  Container(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 10),
                    child: Row(children: [
                      const Text(
                        'Hola,',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' ${getFirstWord(authProvider.globalUser?.fullName)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                  )
                ],
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
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: Consumer<AccountsProvider>(
                        builder: (context, accountsProvider, _) {
                          double totalBalance =
                              accountsProvider.getTotalBalance();
                          return buildHeaderContent(
                              context, currentTheme, totalBalance);
                        },
                      ),
                    ),
                  ],
                ),
                centerTitle: false, // Ajusta según necesites
                /* title: (_showTitle)
                    ? AnimatedOpacity(
                        opacity: _showTitle ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(children: [
                            const Text(
                              'Hola,',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' ${authProvider.globalUser?.fullName}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                      )
                    : const Text(''),
              
               */
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
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        (!kIsWeb)
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddAccountScreen()))
                            : _launchUrl();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<AccountsProvider>(
                builder: (context, accountsProvider, child) {
                  return Container(
                    padding: const EdgeInsets.all(0.0),
                    height: accountsProvider.accounts.isEmpty
                        ? MediaQuery.of(context).size.height * 0.10
                        : MediaQuery.of(context).size.height * 0.230,
                    child: accountsProvider.accounts.isEmpty
                        ? const Center(
                            child: Text(
                              "No tienes cuentas agregadas.",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: accountsProvider.accounts.length,
                            itemBuilder: (context, index) {
                              final account = accountsProvider.accounts[index];

                              return Hero(
                                tag: 'cardsHome-${account.name}',
                                child: GestureDetector(
                                  onTap: () => _handleCardTap(context, account),
                                  child: _buildAccountCard(account),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<AccountsProvider>(
                builder: (context, accountsProvider, child) {
                  return Container(
                      padding: const EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height * 0.235,
                      child: accountsProvider.accounts.isEmpty
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Última Transacción',
                                      style: TextStyle(
                                          fontSize: defaultTitle,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              currentTheme.getSubtitleColor()),
                                    ),
                                    accountsProvider.accounts.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {},
                                          )
                                        : Container(),
                                  ],
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                const Center(
                                  child: Text(
                                    "Tus movimientos apareceran aquí.",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Último Movimiento',
                                      style: TextStyle(
                                          fontSize: defaultTitle,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              currentTheme.getSubtitleColor()),
                                    ),
                                    accountsProvider.accounts.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {},
                                          )
                                        : Container(),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0, left: 16.0, right: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      TransactionsDashList(), // ✅ Llama al componente corregido
                                    ],
                                  ),
                                ),
                              ],
                            ));
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    height: MediaQuery.of(context).size.width *
                        2, // Ajusta la altura según tu diseño
                    child: const BudgetedExpensesChart(),
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
                            onTap: () => (),
                            // _handleCardTap(context, myProducts[index]),
                            child: Hero(
                              tag: 'cardsHome-${myProducts[index].cardNumber}',
                              child: myProducts[index],
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => (),
                            // _handleCardTap(context, myProducts[index]),
                            child: InfoCardsAmounts(
                              fileInfo: myProducts[index].fileInfo,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => (),
                            // _handleCardTap(context, myProducts[index]),
                            child: TransactionsDashBoardList(
                              transactions: myProducts[index].transactions,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => (),
                            //_handleCardTap(context, myProducts[index]),
                            child: const BudgetedExpensesChart(),
                          ),
                          const SizedBox(
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

  Widget _buildAccountCard(Account account) {
    return AccountCard(account: account);
  }

  BoxDecoration _getBackgroundDecoration(String type) {
    switch (type) {
      case "Cuenta Corriente":
        return BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)], // Azul
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case "Cuenta de Ahorro":
        return BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF2E7D32)], // Verde
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case "Efectivo":
        return BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB300), Color(0xFFFF6F00)], // Naranja
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      default:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF607D8B), Color(0xFF455A64)], // Gris oscuro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
    }
  }

  void _handleCardTap(BuildContext context, Account card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetail(card: card),
      ),
    );
  }

  Widget buildHeaderContent(
      BuildContext context, ThemeProvider themeProvider, double balance) {
    final financialData = Provider.of<FinancialDataService>(context);

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
          const SizedBox(height: 6),
          Animate(
            effects: const [FadeEffect(), ScaleEffect()],
            child: Consumer<FinancialDataService>(
              builder: (context, financialData, _) {
                return Text(
                  formatCurrency(financialData.getBalanceTotal()),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Consumer<FinancialDataService>(
            builder: (context, financialData, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildIndicator(
                    icon: Icons.arrow_upward,
                    title: 'Ingresado',
                    amount: formatAbrevCurrency(financialData
                        .getTotalIngresado()), // ✅ Ahora es dinámico
                    context: context,
                    isPositive: true,
                    themeProvider: themeProvider,
                  ),
                  const SizedBox(width: 16),
                  buildIndicator(
                    icon: Icons.arrow_downward,
                    title: 'Gastado',
                    amount: formatAbrevCurrency(
                        financialData.getTotalGastado()), // ✅ Ahora es dinámico
                    context: context,
                    isPositive: false,
                    themeProvider: themeProvider,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildIndicator({
    required IconData icon,
    required String title,
    required String amount,
    required BuildContext context,
    required bool isPositive,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPositive
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
            ),
            child: Icon(
              icon,
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
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
                amount,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fade(duration: 400.ms),
            ],
          ),
        ],
      ),
    );
  }
}
