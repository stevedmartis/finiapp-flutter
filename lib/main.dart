import 'package:finia_app/firebase_options.dart';
import 'package:finia_app/helper/lifecycle_event.dart';
import 'package:finia_app/screens/credit_card/credit_cards_page.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/login/sign_in.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:finia_app/services/token_interceptor.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('es_ES');

  AuthService authService = AuthService();
  InterceptedClient client =
      InterceptedClient.build(interceptors: [TokenInterceptor(authService)]);

  runApp(MyApp(client: client, authService: authService));
}

class MyApp extends StatelessWidget {
  final InterceptedClient client;
  final AuthService authService;

  MyApp({required this.client, required this.authService});

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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            key: navigatorKey,
            locale: Locale('es', 'ES'),
            debugShowCheckedModeBanner: false,
            title: 'finIA',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode, // Usa el tema oscuro
            routes: {
              '/mainScreen': (context) => MainScreen(),
              '/signIn': (context) => SignIn(),
              '/cards': (context) => CreditCardDemo(),
            },
            home: Consumer<AuthService>(
              builder: (context, auth, _) {
                if (auth.isLoading) {
                  return CircularProgressIndicator();
                } else {
                  return auth.isAuthenticated ? MainScreen() : SignIn();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
