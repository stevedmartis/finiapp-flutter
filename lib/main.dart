import 'package:finia_app/screens/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/sign_in.dart';
import 'package:finia_app/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuAppController =
        MenuAppController(); // Crea una instancia de MenuAppController aquí

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: menuAppController,
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(), // Añade el AuthProvider aquí
        ),
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
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isAuthenticated
                ? MainScreen(menuAppController: menuAppController)
                : SignIn(); // Controla el acceso basado en la autenticación
          },
        ),
      ),
    );
  }
}
