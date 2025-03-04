import 'package:finia_app/firebase_options.dart';
import 'package:finia_app/helper/lifecycle_event.dart';
import 'package:finia_app/screens/credit_card/credit_cards_page.dart';
import 'package:finia_app/screens/login/onboarding_page.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:finia_app/shared_preference/global_preference.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //await resetOnboarding();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasCompletedOnboarding =
      prefs.getBool("hasCompletedOnboarding") ?? false;

  print("🔴 Datos en SharedPreferences al iniciar la app: ${prefs.getKeys()}");
  print("🔴 Cuentas guardadas: ${prefs.getString("accounts")}");

  await initializeDateFormatting('es_ES');

  AuthService authService = AuthService();
  AccountsProvider accountsProvider = AccountsProvider();

  if (hasCompletedOnboarding) {
    await accountsProvider.loadAccounts();
  }
  InterceptedClient client =
      InterceptedClient.build(interceptors: [TokenInterceptor(authService)]);

  runApp(MyApp(
      client: client,
      authService: authService,
      hasCompletedOnboarding: hasCompletedOnboarding,
      accountsProvider: accountsProvider)); // ✅ Pasamos el provider ya cargado
}

Future<void> resetOnboarding() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("hasCompletedOnboarding"); // 🔥 Elimina la clave guardada`
}

class MyApp extends StatelessWidget {
  final InterceptedClient client;
  final AuthService authService;
  final bool hasCompletedOnboarding;
  final AccountsProvider accountsProvider; // ✅ Recibe el provider cargado

  const MyApp({
    super.key,
    required this.client,
    required this.authService,
    required this.hasCompletedOnboarding,
    required this.accountsProvider, // ✅ Lo pasamos aquí
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        onResumed: () => authService.checkSession(),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        ChangeNotifierProvider(create: (context) => FinancialDataService()),
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider.value(
            value: accountsProvider), // ✅ Se usa el que ya está cargado
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
                return hasCompletedOnboarding
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
