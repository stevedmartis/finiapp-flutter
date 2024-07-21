import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignupWithPhonePage extends StatelessWidget {
  const SignupWithPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery para obtener las dimensiones de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop =
        screenWidth > 600; // Asumimos que es desktop si el ancho es mayor a 600

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              // Diseño de escritorio con imagen a la izquierda y contenido a la derecha
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SvgPicture.asset(
                      "assets/images/signup-illustration.svg",
                      height: screenHeight,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildContent(context),
                  ),
                ],
              );
            } else {
              // Diseño vertical para dispositivos móviles
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/signup-illustration.svg",
                      width: screenWidth * 0.8, // Ajusta el tamaño de la imagen
                    ),
                    _buildContent(context),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Esta función construye el contenido a la derecha de la imagen para desktop
    // o debajo de la imagen para dispositivos móviles
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignupWithPhone(
            name: "Entrar con mi número de celular",
            onPressed: () {
              // Define la lógica al presionar aquí
            },
          ),
          const SizedBox(height: 16), // Espacio entre botones
          // Agrega más widgets si es necesario
        ],
      ),
    );
  }
}

class SignupWithPhone extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const SignupWithPhone({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      width: double
          .infinity, // Asegura que el botón se extienda en el ancho disponible
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          minimumSize: const Size.fromHeight(40),
          padding: const EdgeInsets.all(16.0),
          backgroundColor: themeProvider.getCardColor(),
        ),
        child: Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: themeProvider.getSubtitleColor()),
        ),
      ),
    );
  }
}
