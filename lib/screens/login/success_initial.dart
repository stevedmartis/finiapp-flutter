import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 500);

enum DataBackupState {
  initial,
  start,
  end,
}

class SuccessInitialPage extends StatefulWidget {
  const SuccessInitialPage({
    super.key,
    required this.onAnimationStarted,
    required this.progressAnimation,
  });
  final VoidCallback onAnimationStarted;
  final Animation<double> progressAnimation;

  @override
  DataBackupInitialPageState createState() => DataBackupInitialPageState();
}

class DataBackupInitialPageState extends State<SuccessInitialPage> {
  final DataBackupState _currentState = DataBackupState.initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_currentState == DataBackupState.end)
            Expanded(
              flex: 2,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: _duration,
                builder: (_, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ProgressCounter(
                            animation: widget.progressAnimation,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class ProgressCounter extends AnimatedWidget {
  const ProgressCounter({
    super.key,
    required Animation<double> animation,
  }) : super(listenable: animation);

  double get value => (listenable as Animation<double>).value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(value * 100).truncate().toString()}%',
    );
  }
}
