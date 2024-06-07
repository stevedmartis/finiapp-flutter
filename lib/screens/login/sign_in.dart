import 'package:finia_app/constants.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:finia_app/screens/login/phone_login.dart';
import 'package:finia_app/widgets/horizontal_line.dart';
import 'package:finia_app/widgets/signup_with_phone.dart';
import 'package:finia_app/widgets/social_button.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar MediaQuery para determinar el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = screenWidth > 600; // Un simple criterio para "escritorio"

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determinar si estamos en modo escritorio basándonos en el ancho
            if (isDesktop) {
              return Row(
                // Layout para escritorio con dos columnas
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/images/signup-vector.svg",
                      // Ajustar la altura de la imagen para escritorio
                      height: screenHeight,
                    ),
                  ),
                  Expanded(
                    child: _buildButtons(
                        context), // Botones a la derecha para escritorio
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                // Layout vertical para móviles con scroll
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/signup-vector.svg",
                      // Usar un porcentaje del ancho del dispositivo para la imagen
                      width: screenWidth *
                          0.8, // Ajusta este valor según sea necesario
                    ),
                    _buildButtons(
                        context), // Botones debajo de la imagen para móviles
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    // Determinar el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSpacing =
        screenWidth > 600 ? 16.0 : 8.0; // Espaciado más grande para escritorio

    return Container(
      padding: EdgeInsets.all(screenWidth / 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SocialButton(
            name: "Continue with Facebook",
            icon: "assets/icons/facebook.svg",
            onPressed: () {
              // Aquí manejarías el inicio de sesión con Facebook
            },
          ),
          SizedBox(height: buttonSpacing), // Espacio entre botones
          SocialButton(
            name: "Continue with Google",
            icon: "assets/icons/google.svg",
            onPressed: () => _signInWithGoogle(context),
          ),
          SizedBox(height: buttonSpacing), // Espacio entre botones
          SocialButton(
            name: "Continue with Apple",
            icon: "assets/icons/apple-logo.svg",
            onPressed: () {
              // Aquí manejarías el inicio de sesión con Apple
            },
            appleLogo: true,
          ),
          SizedBox(
              height:
                  buttonSpacing * 2), // Espacio más grande antes de la línea
          HorizontalLine(name: "Or", height: 0.1),
          SizedBox(height: buttonSpacing), // Espacio después de la línea
          SignupWithPhone(
            name: defaultSignPhoneTitle,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PhoneLogin()));
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20), // Ajustar el padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    // Aquí manejarías la navegación al registro de usuarios
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signInWithGoogle(BuildContext context) async {
    // Accede a AuthProvider usando Provider.of<>
    final authProvider = Provider.of<AuthService>(context, listen: false);

    // Llama a signInWithGoogle en AuthProvider
    await authProvider.signInWithGoogle();

    // Verifica si el usuario está autenticado
    if (authProvider.isAuthenticated) {
      print("Inicio de sesión exitoso");
    } else {
      print("Error de inicio de sesión");
      // Muestra un Snackbar en caso de error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inicio de sesión fallido")));
    }
  }
}
