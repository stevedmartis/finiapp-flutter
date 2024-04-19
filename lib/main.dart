import 'package:finia_app/firebase_options.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/login/sign_in.dart';
import 'package:finia_app/theme/app_theme.dart';
import 'package:finia_app/constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:finia_app/services/token_interceptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AuthService authService = AuthService();
  InterceptedClient client =
      InterceptedClient.build(interceptors: [TokenInterceptor(authService)]);

  await authService.loadUserData();

  runApp(MyApp(client: client, authService: authService));
}

class MyApp extends StatelessWidget {
  final InterceptedClient client;
  final AuthService authService;

  MyApp({required this.client, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        ChangeNotifierProvider(
            create: (context) => authService), // This line has been updated
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Admin Panel',
        theme: AppTheme.theme.copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, _) =>
              auth.isAuthenticated ? MainScreen() : SignIn(),
        ),
      ),
    );
  }
}
