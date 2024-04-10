import 'dart:async';

import 'package:flutter/material.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/screens/phone_login.dart';
import 'package:finia_app/widgets/signup_with_phone.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

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
    super.initState();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PhoneLogin()),
          ),
        ),
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
                  onCompleted: (pin) {
                    // Implement verification logic here
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
                              // Logic to resend code
                            }
                          : null,
                      child: Text(
                        !enableResend
                            ? secondsRemaining.toString()
                            : "Resend code",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SignupWithPhone(
                  name: "Verify",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
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
