import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:finia_app/screens/sign_in.dart';
import 'package:finia_app/screens/verification.dart';
import 'package:finia_app/widgets/phone_number_field.dart';
import 'package:finia_app/widgets/remember_me.dart';
import 'package:finia_app/widgets/signup_with_phone.dart';

class PhoneLogin extends StatelessWidget {
  const PhoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar MediaQuery para determinar el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600; // Un simple criterio para "escritorio"

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              // Diseño de escritorio con dos columnas
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/images/signup-vector.svg",
                      height: constraints.maxHeight,
                    ),
                  ),
                  Expanded(
                    child: _buildForm(context),
                  ),
                ],
              );
            } else {
              // Diseño vertical para dispositivos móviles
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/signup-vector.svg",
                      width: screenWidth * 0.8,
                    ),
                    _buildForm(context),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    // Método para construir el formulario de inicio de sesión
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Login to your Account",
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24.0),
          ),
          const PhoneNumberField(),
          const RememberMe(),
          SignupWithPhone(
            name: "Sign in",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Verification(),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              TextButton(
                onPressed: () {},
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
        ],
      ),
    );
  }
}
