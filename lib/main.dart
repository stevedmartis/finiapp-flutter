import 'package:finia_app/firebase_options.dart';
import 'package:finia_app/helper/lifecycle_event.dart';
import 'package:finia_app/screens/credit_card/credit_cards_page.dart';
import 'package:finia_app/screens/login/onboarding_page.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/login/sign_in.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:finia_app/services/token_interceptor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Necesario para async en main()

  //await resetOnboarding();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasCompletedOnboarding =
      prefs.getBool("hasCompletedOnboarding") ?? false;

  await initializeDateFormatting('es_ES');

  AuthService authService = AuthService();
  AccountsProvider accountsProvider = AccountsProvider();
  TransactionProvider transactionProvider = TransactionProvider();
  FinancialDataService financialProvider = FinancialDataService();

  if (hasCompletedOnboarding) {
    await transactionProvider.clearTransactions();
    await accountsProvider.clearAccounts();
    await accountsProvider.loadAccounts();
    await transactionProvider.loadTransactions();

    financialProvider.initializeData();
  }
  InterceptedClient client =
      InterceptedClient.build(interceptors: [TokenInterceptor(authService)]);

  // ✅ Cargar datos desde aÎpi funancySummary
/*   Future.delayed(Duration.zero, () async {
    final financialProvider =
        Provider.of<FinancialDataService>(context, listen: false);
    await financialProvider.fetchFinancialSummary('USER_ID');
  }); */

  runApp(MyApp(
    client: client,
    authService: authService,
    hasCompletedOnboarding: hasCompletedOnboarding,
    accountsProvider: accountsProvider,
    transactionProvider: transactionProvider,
  ));
}

Future<void> resetOnboarding() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("hasCompletedOnboarding"); // 🔥 Elimina la clave guardada`
}

class MyApp extends StatefulWidget {
  final InterceptedClient client;
  final AuthService authService;
  final bool hasCompletedOnboarding;
  final AccountsProvider accountsProvider;
  final TransactionProvider transactionProvider; // ✅ Recibe el provider cargado

  const MyApp({
    super.key,
    required this.client,
    required this.authService,
    required this.hasCompletedOnboarding,
    required this.accountsProvider,
    required this.transactionProvider,
    // ✅ Lo pasamos aquí
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        onResumed: () => widget.authService.checkSession(),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        ChangeNotifierProvider(create: (context) => FinancialDataService()),
        ChangeNotifierProvider.value(value: widget.authService),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider.value(value: widget.accountsProvider),
        ChangeNotifierProvider.value(
            value:
                widget.transactionProvider) // ✅ Se usa el que ya está cargado
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            key: navigatorKey,
            locale: const Locale('es', 'ES'),
            debugShowCheckedModeBanner: false,
            title: 'finIA',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode, // Usa el tema oscuro
            routes: {
              '/mainScreen': (context) => const MainScreen(),
              '/signIn': (context) => const SignIn(),
              '/cards': (context) => const CreditCardDemo(),
              '/onB': (context) => const OnboardingScreen(),
            },
            home: Consumer<AuthService>(
              builder: (context, auth, _) {
                if (!auth.isAuthenticated) {
                  return const SignIn();
                }
                return widget.hasCompletedOnboarding
                    ? const MainScreen()
                    : const OnboardingScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
