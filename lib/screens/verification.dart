import 'dart:async';

import 'package:flutter/material.dart';
import 'package:finia_app/helper/colors.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/phone_login.dart';
import 'package:finia_app/widgets/signup_with_phone.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/screens/providers/auth_provider.dart';
import 'package:finia_app/controllers/MenuAppController.dart'; // Importa MenuAppController

class Verification extends StatefulWidget {
  const Verification({Key? key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late TextEditingController _verification;
  late Timer timer;
  int secondsRemaining = 30;
  bool enableResend = false;

  @override
  void initState() {
    _verification = TextEditingController();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _verification.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600;

    // Obtiene la instancia de MenuAppController
    final menuAppController = context.read<MenuAppController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PhoneLogin()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? screenWidth * 0.2 : 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Code has been sent to +91 *********1245",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Pinput(
                  length: 6,
                  showCursor: true,
                  pinAnimationType: PinAnimationType.slide,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: PinTheme(
                    decoration: BoxDecoration(
                      color: ColorSys.kSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    width: 50,
                  ),
                  onCompleted: (pin) {
                    // Verificar el PIN
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !enableResend ? const Text("Resend code in ") : Container(),
                    TextButton(
                      onPressed: enableResend
                          ? () {
                              // Lógica para reenviar el código
                            }
                          : null,
                      child: Text(
                        !enableResend
                            ? secondsRemaining.toString()
                            : "Resend code",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SignupWithPhone(
                  name: "Verify",
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).signIn();

                    // Navegar a la pantalla principal, pasando menuAppController
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(
                                menuAppController: menuAppController,
                              )),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
