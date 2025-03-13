import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'package:finia_app/models/budget_distribution_dto.dart';
import 'package:finia_app/models/finance_summary.dart';
import 'package:finia_app/models/financial_health_dto.dart';
import 'package:finia_app/models/financial_tip_dto.dart';
import 'package:finia_app/models/payment_dto.dart';
import 'package:finia_app/models/savind_dto.dart';
import 'package:finia_app/screens/credit_card/account_cards_widget.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/custom_nav_bar.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/dashboard/pages/financial_health.dart';
import 'package:finia_app/screens/dashboard/pages/financial_tips.dart';
import 'package:finia_app/screens/dashboard/pages/resume_50_20_30.dart';
import 'package:finia_app/screens/dashboard/pages/saving_goals.dart';
import 'package:finia_app/screens/dashboard/pages/upcoming_payment.dart';
import 'package:finia_app/screens/dashboard/transactions/transaction_add_form.dart';
import 'package:finia_app/screens/dashboard/transactions/transaction_dash_list.dart';
import 'package:finia_app/screens/login/add_accouts_explain_page.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:finia_app/utilis/format_currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountWithSummary {
  final Account account;
  final FinancialSummary summary;
  final TransactionProvider transactionProvider;

  AccountWithSummary({
    required this.account,
    required this.summary,
    required this.transactionProvider,
  });

  double getCalculatedBalance(TransactionProvider transactionProvider) {
    // ✅ Tomar el saldo inicial desde el resumen financiero (NO desde account.balance)
    double initialBalance = summary.balance;

    // ✅ Obtener ingresos y gastos desde las transacciones
    double totalIncome =
        transactionProvider.getTotalIncomeForAccount(account.id) ?? 0;
    double totalExpenses =
        transactionProvider.getTotalExpensesForAccount(account.id) ?? 0;

    // ✅ Calcular el balance correctamente
    double calculatedBalance = initialBalance + totalIncome - totalExpenses;

    print(
        "✅ Account ID: ${account.id} → Ingresos: $totalIncome | Gastos: $totalExpenses | Balance Inicial: $initialBalance | Balance Calculado: $calculatedBalance");

    return calculatedBalance;
  }
}

class DashBoardHomeScreen extends StatefulWidget {
  const DashBoardHomeScreen({super.key});
  @override
  State<DashBoardHomeScreen> createState() => DashBoardHomeScreenState();
}

class DashBoardHomeScreenState extends State<DashBoardHomeScreen> {
  late ScrollController _scrollController;
  late MenuAppController menuAppController;

  List<PaymentDto> _upcomingPayments = [];
  List<SavingGoalDto> _savingGoals = [];
  List<FinancialTipDto> _financialTips = [];
  FinancialHealthDto? _financialHealth;
  BudgetDistributionDto? _budgetDistribution;

  String? _currentAccountId;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool showTitle = false;

  @override
  void initState() {
    super.initState();

    _loadData();

    // En initState
    _budgetDistribution = BudgetDistributionDto(
      totalIncome: 3500000,
      needsSpent: 2000000,
      wantsSpent: 200000,
      savingsSpent: 0,
    );

    _financialHealth = FinancialHealthDto(
      score: 65,
      status: "Buena",
      message:
          "Tu situación financiera es buena, pero hay espacio para mejorar.",
      improvementTips: [
        "Incrementa tu ahorro mensual",
        "Reduce gastos en comidas"
      ],
      categoryScores: {
        'budget': 70,
        'savings': 50,
        'debt': 80,
        'spending': 60,
        'goals': 50,
      },
    );

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

  Future<void> _loadData() async {
    final accountsProvider =
        Provider.of<AccountsProvider>(context, listen: false);
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    // Solo cargar datos de prueba si no hay datos reales
    if (_savingGoals.isEmpty) {
      setState(() {
        // Solo si hay cuentas, crear metas de prueba
        if (accountsProvider.accounts.isNotEmpty) {
          _savingGoals = [
            SavingGoalDto(
              id: '1',
              name: 'Fondo de emergencia',
              category: 'Emergencia',
              targetAmount:
                  accountsProvider.getTotalIncome() * 3, // 3 meses de ingresos
              currentAmount:
                  accountsProvider.getTotalIncome() * 0.5, // Medio mes guardado
              targetDate: DateTime.now().add(const Duration(days: 180)),
            ),
          ];
        }

        // Consejos financieros basados en el estado actual
        if (accountsProvider.accounts.isNotEmpty) {
          _financialTips = [
            FinancialTipDto(
              id: '1',
              title: 'Optimiza tu distribución 50/30/20',
              description: transactionProvider.transactions.isEmpty
                  ? 'Comienza a registrar tus gastos para mejorar tu planificación financiera.'
                  : 'Mejora tu distribución de gastos para acercarte al ideal 50/30/20.',
              type: 'budget',
            ),
          ];
        }
      });
    }

    // Luego calcular la salud financiera con los datos actualizados
    _calculateFinancialHealth();
  }

  // Método para calcular la salud financiera
  void _calculateFinancialHealth() {
    final accountsProvider =
        Provider.of<AccountsProvider>(context, listen: false);
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    // No calcular nada si no hay cuentas
    if (accountsProvider.accounts.isEmpty) {
      setState(() {
        _financialHealth = null;
        _budgetDistribution = null;
      });
      return;
    }

    // Obtener datos financieros actuales
    final totalIncome = accountsProvider.getTotalIncome();
    final totalExpenses = transactionProvider.getTotalExpenses();

    // Si no hay transacciones, establecer valores de ahorro y deuda en 0
    final totalSavings = transactionProvider.transactions.isEmpty
        ? 0.0
        : transactionProvider.getTotalSavings().toDouble();

    final totalDebt = accountsProvider.getTotalDebt();

    // Solo calcular si hay ingresos (para evitar división por cero)
    if (totalIncome <= 0) {
      setState(() {
        _financialHealth = null;
        _budgetDistribution = null;
      });
      return;
    }

    // Calcular salud financiera
    setState(() {
      // Solo si hay transacciones
      if (transactionProvider.transactions.isNotEmpty) {
        _financialHealth = FinancialHealthDto.calculate(
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          totalSavings: totalSavings,
          totalDebt: totalDebt,
          transactions: transactionProvider.transactions,
          savingGoals: _savingGoals,
        );
      } else {
        _financialHealth = null;
      }

      // Siempre calcular la distribución del presupuesto, incluso sin transacciones
      _budgetDistribution = BudgetDistributionDto(
        totalIncome: totalIncome,
        needsSpent: transactionProvider.transactions.isEmpty
            ? 0
            : transactionProvider.transactions
                .where((t) =>
                    t.type == "Gasto" &&
                    [
                      "Comida",
                      "Salud",
                      "Arriendo",
                      "Servicios",
                      "Hogar",
                      "Transporte",
                      "Gasolina"
                    ].contains(t.category))
                .fold(0, (sum, t) => sum + t.amount),
        wantsSpent: transactionProvider.transactions.isEmpty
            ? 0
            : transactionProvider.transactions
                .where((t) =>
                    t.type == "Gasto" &&
                    [
                      "Ocio",
                      "Ropa",
                      "Videojuegos",
                      "Streaming",
                      "Viajes",
                      "Regalos"
                    ].contains(t.category))
                .fold(0, (sum, t) => sum + t.amount),
        savingsSpent: transactionProvider.transactions.isEmpty
            ? 0
            : transactionProvider.transactions
                .where((t) =>
                    t.type == "Gasto" &&
                    ["Ahorro", "Inversión"].contains(t.category))
                .fold(0, (sum, t) => sum + t.amount),
      );
    });
  }

  // Método para marcar un pago como completado
  void _markPaymentAsPaid(PaymentDto payment) {
    setState(() {
      final index = _upcomingPayments.indexWhere((p) => p.id == payment.id);
      if (index != -1) {
        _upcomingPayments[index] =
            _upcomingPayments[index].copyWith(isPaid: true);
        // Aquí también llamarías al servicio para guardar el cambio
      }
    });
  }

  // Método para navegación a añadir nueva meta
  void _navigateToAddGoal() {
    // Implementar navegación a pantalla de añadir meta
    // Navigator.push(context, MaterialPageRoute(...));
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

    final accountsProvider =
        Provider.of<AccountsProvider>(context, listen: true);

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    final currentAccountId =
        Provider.of<AccountsProvider>(context, listen: true).currentAccountId;

// Para el header superior de tu app (donde muestras $1.3M balance total)
    final totalIncome = accountsProvider.getTotalIncome().toDouble();
    final totalExpenses = transactionProvider.getTotalExpenses().toDouble();
    final totalBalance = totalIncome - totalExpenses;

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
                        color: currentTheme.getSubtitleColor(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
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

// Estado vacío para cuentas - Simplificado para evitar overflow
            SliverToBoxAdapter(
              child: Consumer3<FinancialDataService, AccountsProvider,
                  TransactionProvider>(
                builder: (context, financialData, accountsProvider,
                    transactionProvider, _) {
                  final combinedAccounts = financialData.getCombinedAccounts(
                    accountsProvider.accounts,
                    transactionProvider,
                  );

                  if (combinedAccounts.isEmpty) {
                    // Enfoque simplificado para evitar overflow
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242230),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // Sin altura fija para adaptarse naturalmente
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 32,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No tienes cuentas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Añade tu primera cuenta para comenzar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  (!kIsWeb)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddAccountScreen()))
                                      : _launchUrl();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Añadir Cuenta'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 160, // Altura reducida
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: combinedAccounts.length,
                      itemBuilder: (context, index) {
                        final accountSummary = combinedAccounts[index];
                        return Hero(
                          tag: 'cardsHome-${accountSummary.account.name}',
                          child: GestureDetector(
                            onTap: () =>
                                _handleCardTap(context, accountSummary),
                            child: _buildAccountCard(accountSummary),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

// Título de Actividad Reciente
            SliverToBoxAdapter(
              child: Consumer<AccountsProvider>(
                builder: (context, accountsProvider, _) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Actividad Reciente',
                          style: TextStyle(
                            fontSize: defaultTitle,
                            fontWeight: FontWeight.bold,
                            color: currentTheme.getSubtitleColor(),
                          ),
                        ),
                        if (accountsProvider.accounts.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) =>
                                    const AddTransactionBottomSheet(),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Consumer2<AccountsProvider, TransactionProvider>(
                builder: (context, accountsProvider, transactionProvider, _) {
                  if (accountsProvider.accounts.isEmpty ||
                      transactionProvider.transactions.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242230),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 32,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No tienes movimientos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                accountsProvider.accounts.isEmpty
                                    ? 'Primero añade una cuenta para registrar movimientos'
                                    : 'Registra tu primera transacción',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (accountsProvider.accounts.isEmpty) {
                                    // Si no hay cuentas, primero dirigir a crear una cuenta
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Primero debes crear una cuenta'),
                                        action: SnackBarAction(
                                          label: 'Crear',
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
                                      ),
                                    );
                                  } else {
                                    // Si hay cuentas, mostrar el modal para añadir transacción
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) =>
                                          const AddTransactionBottomSheet(),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  accountsProvider.accounts.isEmpty
                                      ? 'Añadir Cuenta'
                                      : 'Añadir Transacción',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Si hay transacciones
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        TransactionsDashList(),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Y luego, para tu widget Rule50_30_20Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: accountsProvider.accounts.isNotEmpty
                    ? Rule50_30_20Widget(
                        totalIncome: totalIncome,
                        totalNeeds: transactionProvider.transactions
                            .where((t) =>
                                t.type == "Gasto" &&
                                [
                                  "Comida",
                                  "Salud",
                                  "Arriendo",
                                  "Servicios",
                                  "Hogar",
                                  "Transporte",
                                  "Gasolina"
                                ].contains(t.category))
                            .fold(0.0, (sum, t) => sum + t.amount),
                        totalWants: transactionProvider.transactions
                            .where((t) =>
                                t.type == "Gasto" &&
                                [
                                  "Ocio",
                                  "Ropa",
                                  "Videojuegos",
                                  "Streaming",
                                  "Viajes",
                                  "Regalos"
                                ].contains(t.category))
                            .fold(0.0, (sum, t) => sum + t.amount),
                        totalSavings: transactionProvider.transactions
                            .where((t) =>
                                (t.type == "Ingreso" || t.type == "Gasto") &&
                                ["Ahorro", "Inversión"].contains(t.category))
                            .fold(0.0, (sum, t) => sum + t.amount),
                      )
                    : SizedBox.shrink(),
              ),
            ),
            // NUEVO: Tarjeta de Salud Financiera
            if (_financialHealth != null &&
                accountsProvider.accounts.isNotEmpty)
              // En tu dashboard donde usas el widget
              if (_financialHealth != null &&
                  accountsProvider.accounts.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FinancialHealthCard(
                      // Pass the score, potentially null if no transactions
                      score: transactionProvider.transactions.isEmpty
                          ? null
                          : _financialHealth?.score,

                      // Use the existing message or a default
                      message: _financialHealth?.message ??
                          "Evaluando tu salud financiera...",

                      // Use existing tips or provide a default
                      tips: _financialHealth?.improvementTips ??
                          [
                            "Registra tus primeros gastos para recibir consejos personalizados"
                          ],

                      // Total account balance
                      accountBalance: accountsProvider.getTotalIncome(),

                      // Total needs (from your transaction categories)
                      totalNeeds: transactionProvider.getTotalNeedsExpenses(),

                      // Total wants (from your transaction categories)
                      totalWants: transactionProvider.getTotalWantsExpenses(),

                      // Total savings (from your transaction categories)
                      totalSavings: transactionProvider.getTotalSavings(),

                      // Existing callback for adding transactions
                      onAddTransactionPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) =>
                              const AddTransactionBottomSheet(),
                        );
                      },
                    ),
                  ),
                ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Consumer3<FinancialDataService, AccountsProvider,
                      TransactionProvider>(
                    builder: (context, financialData, accountsProvider,
                        transactionProvider, _) {
                      final currentAccount =
                          accountsProvider.getCurrentAccount();
                      final transactions = transactionProvider.transactions;

                      // Caso donde no hay cuenta o no hay transacciones
                      if (currentAccount == null || transactions.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF242230),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.pie_chart_outline,
                                  size: 32,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Estadísticas no disponibles',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    currentAccount == null
                                        ? 'Selecciona una cuenta para ver estadísticas'
                                        : 'Registra transacciones para visualizar tus gastos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (currentAccount == null) {
                                        // Si no hay cuenta seleccionada
                                        (!kIsWeb)
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddAccountScreen(),
                                                ),
                                              )
                                            : _launchUrl();
                                      } else {
                                        // Si hay cuenta pero no transacciones
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) =>
                                              const AddTransactionBottomSheet(),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      currentAccount == null
                                          ? 'Añadir Cuenta'
                                          : 'Añadir Transacción',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Si hay datos, mostrar el gráfico
                      final totalAvailable =
                          financialData.getTotalDisponible(accountsProvider);

                      return Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BudgetedExpensesChart(
                          transactions: transactions,
                        ),
                      );
                    },
                  );
                },
                childCount: 1,
              ),
            ),

            // NUEVO: Pagos Próximos
            if (accountsProvider.accounts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                  child: UpcomingPaymentsWidget(
                    upcomingPayments: _upcomingPayments,
                    onPaymentMarked: _markPaymentAsPaid,
                  ),
                ),
              ),

            // NUEVO: Metas de Ahorro
            if (accountsProvider.accounts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
                  child: SavingGoalsWidget(
                    goals: _savingGoals,
                    onAddGoal: _navigateToAddGoal,
                  ),
                ),
              ),

            // NUEVO: Consejos Financieros
            if (_financialTips.isNotEmpty &&
                accountsProvider.accounts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FinancialTipsWidget(
                    tips: _financialTips,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(AccountWithSummary account) {
    return AccountCard(accountSumarry: account);
  }

  void _handleCardTap(BuildContext context, AccountWithSummary accountSummary) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetail(accountSummary: accountSummary),
      ),
    );
  }

  Widget buildHeaderContent(
      BuildContext context, ThemeProvider themeProvider, double balance) {
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
            // ✅ Ahora usamos Consumer2 para pasar el `accountsProvider`
            child: Consumer2<FinancialDataService, AccountsProvider>(
              builder: (context, financialData, accountsProvider, _) {
                double balanceTotal =
                    financialData.getBalanceTotal(accountsProvider);

                // ✅ Si no hay cuentas → Mostrar 0 directamente
                if (balanceTotal == 0) {
                  return const Text(
                    '\$0',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }

                // ✅ Si solo hay una cuenta y no hay transacciones → Mostrar directamente el saldo de la cuenta
                if (financialData.financialSummary.length == 1 &&
                    financialData.financialSummary.first.totalIncome == 0 &&
                    financialData.financialSummary.first.totalExpenses == 0) {
                  return Text(
                    formatCurrency(
                        financialData.financialSummary.first.balance),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }

                // ✅ Si hay varias cuentas o transacciones → Mostrar el balance total calculado
                return Text(
                  formatCurrency(balanceTotal),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // ✅ También corregimos el componente de ingresos y gastos
          Consumer2<FinancialDataService, AccountsProvider>(
            builder: (context, financialData, accountsProvider, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildIndicator(
                    icon: Icons.arrow_upward,
                    title: 'Ingresado',
                    amount: formatAbrevCurrency(
                        financialData.getTotalIngresado(accountsProvider)),
                    context: context,
                    isPositive: true,
                    themeProvider: themeProvider,
                  ),
                  const SizedBox(width: 16),
                  buildIndicator(
                    icon: Icons.arrow_downward,
                    title: 'Gastado',
                    amount:
                        formatAbrevCurrency(financialData.getTotalGastado()),
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
