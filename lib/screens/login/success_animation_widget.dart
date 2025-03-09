import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/login/bubles_animation_page.dart';
import 'package:finia_app/screens/login/success_chck.1.2.dart';
import 'package:finia_app/screens/login/success_initial.dart';
import 'package:flutter/material.dart';

//import 'data_backup_completed_page.dart';
//import 'data_backup_initial_page.dart';

const mainDataBackupColor = Color(0xff32D73F);
const secondaryDataBackupColor = Color(0xff3CFF50);

class BublesSuccesPage extends StatefulWidget {
  const BublesSuccesPage({super.key});
  @override
  BublesSuccesPageState createState() => BublesSuccesPageState();
}

class BublesSuccesPageState extends State<BublesSuccesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _cloudOutAnimation;
  late Animation<double> _endingAnimation;
  late Animation<double> _bubblesAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.1,
      ),
    );
    _cloudOutAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.1,
        curve: Curves.easeOut,
      ),
    );
    _bubblesAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.decelerate,
      ),
    );
    _endingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.6,
        1.0,
        curve: Curves.decelerate,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkCardBackground, cardDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SuccessInitialPage(
              progressAnimation: _progressAnimation,
              onAnimationStarted: () {
                _animationController.forward();
              },
            ),
            BubblesAnimationPage(
              progressAnimation: _progressAnimation,
              cloudOutAnimation: _cloudOutAnimation,
              bubblesAnimation: _bubblesAnimation,
            ),
            SuccessCompletePage(
              endingAnimation: _endingAnimation,
            ),
          ],
        ),
      ),
    );
  }
}
