import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 500);

enum DataBackupState {
  initial,
  start,
  end,
}

class SuccessInitialPage extends StatefulWidget {
  const SuccessInitialPage({
    Key? key,
    required this.onAnimationStarted,
    required this.progressAnimation,
  }) : super(key: key);
  final VoidCallback onAnimationStarted;
  final Animation<double> progressAnimation;

  @override
  _DataBackupInitialPageState createState() => _DataBackupInitialPageState();
}

class _DataBackupInitialPageState extends State<SuccessInitialPage> {
  DataBackupState _currentState = DataBackupState.initial;

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
                            widget.progressAnimation,
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

//ignore: must_be_immutable
class ProgressCounter extends AnimatedWidget {
  ProgressCounter(Animation<double> animation) : super(listenable: animation);

  double get value => (listenable as Animation).value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(value * 100).truncate().toString()}%',
    );
  }
}
