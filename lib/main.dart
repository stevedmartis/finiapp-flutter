import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/screens/providers/auth_provider.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/sign_in.dart';
import 'package:finia_app/theme/app_theme.dart';
import 'package:finia_app/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // No se realiza ninguna modificación aquí,
    // ya que estamos manteniendo la estructura original sin eliminar GlobalKey.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              MenuAppController(), // Correcto para instanciar el MenuAppController.
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(), // Añade el AuthProvider aquí.
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
            // Aquí simplemente retornamos MainScreen sin cambios relacionados al GlobalKey.
            return auth.isAuthenticated ? MainScreen() : SignIn();
          },
        ),
      ),
    );
  }
}
