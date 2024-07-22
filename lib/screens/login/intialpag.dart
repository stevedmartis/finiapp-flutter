import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 500);

enum DataBackupState { initial, start, end }

class DataBackupInitialPage extends StatefulWidget {
  final void Function() onAnimationStarted;
  final Animation<double> progressAnimation;
  const DataBackupInitialPage({
    super.key,
    required this.onAnimationStarted,
    required this.progressAnimation,
  });

  @override
  State<DataBackupInitialPage> createState() => _DataBackupInitialPageState();
}

class _DataBackupInitialPageState extends State<DataBackupInitialPage> {
  DataBackupState _currentState = DataBackupState.initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              "Cloud Storage",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          if (_currentState == DataBackupState.end)
            Expanded(
              flex: 2,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 1.0, end: 1.0),
                duration: _duration,
                builder: (_, value, child) {
                  return Opacity(
                    opacity: value as double,
                    child: child,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Uploading files",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FittedBox(
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ProgressCounter(widget.progressAnimation),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          if (_currentState != DataBackupState.end)
            Expanded(
              flex: 2,
              child: TweenAnimationBuilder(
                tween: Tween(
                    begin: 1.0,
                    end: _currentState != DataBackupState.initial ? 0.0 : 1.0),
                duration: _duration,
                onEnd: () {
                  setState(() {
                    _currentState = DataBackupState.end;
                  });
                },
                builder: (_, value, child) {
                  final val = value as double;
                  return Opacity(
                    opacity: val,
                    child: Transform.translate(
                      offset: Offset(0.0, 50 * val),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: const [
                    Text(
                      "last backup:",
                      style: TextStyle(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "28 may 2020",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedSwitcher(
              duration: _duration,
              child: _currentState == DataBackupState.initial
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentState = DataBackupState.start;
                          });
                          widget.onAnimationStarted();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Text("create backup"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: logoCOLOR1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentState = DataBackupState.initial;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: logoCOLOR2,
                            ),
                          ),
                        ),
                      ),
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
  const ProgressCounter(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  double get value => (listenable as Animation).value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(value * 100).truncate().toString()} %',
    );
  }
}
