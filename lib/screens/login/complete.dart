import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DataBackupCompletedPage extends AnimatedWidget {
  final Animation<double> endingAnimation;
  const DataBackupCompletedPage({super.key, required this.endingAnimation})
      : super(listenable: endingAnimation);

  Animation<double> get animation => (listenable as Animation<double>);

  @override
  Widget build(BuildContext context) {
    return animation.value > 0
        ? Positioned.fill(
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomPaint(
                        foregroundPainter:
                            _DataBackupCompletedPainer(animation),
                        child: const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                      ),
                    )),
                const SizedBox(height: 60),
                Expanded(
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    builder: (_, value, child) {
                      final val = value as double;
                      return Opacity(
                        opacity: val,
                        child: Transform.translate(
                          offset: Offset(
                            0.0,
                            50 * (1 - val),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Text(
                          "Data has successfully\n uploaded",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                color: logoCOLOR1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          )
        : const SizedBox.shrink();
  }
}

class _DataBackupCompletedPainer extends CustomPainter {
  final Animation<double> animation;
  _DataBackupCompletedPainer(this.animation) : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = logoCOLOR2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final circlePath = Path();

    circlePath.addArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      vector.radians(-90.0),
      vector.radians(360.0 * animation.value),
    );

    final leftLine = size.width * 0.2;
    final rightLine = size.width * 0.3;

    final leftPercent = animation.value > 0.5 ? 1.0 : animation.value / 0.5;
    final rightPercent =
        animation.value < 0.5 ? 0.0 : (animation.value - 0.5) / 0.5;

    canvas.save();

    canvas.translate(size.width / 3, size.height / 2);
    canvas.rotate(vector.radians(-45));

    canvas.drawLine(Offset.zero, Offset(0.0, leftLine * leftPercent), paint);

    canvas.drawLine(Offset(0.0, leftLine),
        Offset(rightLine * rightPercent, leftLine), paint);

    canvas.restore();

    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
