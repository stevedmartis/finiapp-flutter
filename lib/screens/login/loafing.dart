import 'package:finia_app/screens/login/cloudcomplete.dart';
import 'package:finia_app/screens/login/complete.dart';
import 'package:finia_app/screens/login/intialpag.dart';
import 'package:flutter/material.dart';

const mainDataBackupColor = Color(0xFF5113AA);
const secondaryDataBackupColor = Color(0xFFBC53FA);
const backgroundColor = Color(0xFFFCE7FE);

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _cloudOutAnimation;
  late Animation<double> _endingAnimation;
  late Animation<double> _bubblesAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.65),
    );
    _cloudOutAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 0.85, curve: Curves.easeOut),
    );
    _bubblesAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.decelerate),
    );
    _endingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.8, 1.0, curve: Curves.decelerate),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            DataBackupInitialPage(
              progressAnimation: _progressAnimation,
              onAnimationStarted: () {
                _animationController.forward();
              },
            ),
            DataBackupCloudPage(
              progressAnimation: _progressAnimation,
              cloudOutAnimation: _cloudOutAnimation,
              bubblesAnimation: _bubblesAnimation,
            ),
            DataBackupCompletedPage(
              endingAnimation: _endingAnimation,
            ),
          ],
        ),
      ),
    );
  }
}
