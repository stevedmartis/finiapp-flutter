import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Bubble {
  Bubble({
    required this.color,
    required this.direction,
    required this.speed,
    required this.size,
    required this.initialPosition,
    required this.icon,
    required this.iconColor,
  });

  final Color color;
  final Color iconColor;
  final double direction;
  final double speed;
  final double size;
  final double initialPosition;
  final IconData icon;
}

class BubblesAnimationPage extends StatelessWidget {
  BubblesAnimationPage({
    super.key,
    required this.progressAnimation,
    required this.cloudOutAnimation,
    required this.bubblesAnimation,
  }) {
    _generateBubbles();
  }

  final Animation<double> progressAnimation;
  final Animation<double> cloudOutAnimation;
  final Animation<double> bubblesAnimation;
  late final List<Bubble> bubbles;

  static IconData getIconForCategory(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.train;
      case 'Health':
        return Icons.favorite;
      case 'Leisure':
        return Icons.sports_esports;
      case 'Housing':
        return Icons.home;
      case 'Education':
        return Icons.school;
      case 'Clothing':
        return Icons.checkroom;
      case 'Fast Food':
        return Icons.fastfood;
      case 'Supermarket':
        return Icons.shopping_cart;
      case 'Pets':
        return Icons.pets;
      case 'Technology':
        return Icons.devices;
      case 'Appliances':
        return Icons.kitchen;
      case 'Travel':
        return Icons.flight;
      case 'Savings':
        return Icons.savings;
      case 'Entertainment':
        return Icons.local_pizza;
      case 'Sports':
        return Icons.sports_basketball;
      case 'Beauty':
        return Icons.brush;
      case 'Restaurants':
        return Icons.local_dining;
      case 'Drinks':
        return Icons.local_bar;
      case 'Coffee':
        return Icons.local_cafe;
      case 'Services':
        return Icons.miscellaneous_services;
      case 'Telephony':
        return Icons.phone_iphone;
      case 'Internet':
        return Icons.wifi;
      case 'Electricity':
        return Icons.lightbulb_outlined;
      case 'Water':
        return Icons.opacity;
      case 'Gasoline':
        return Icons.local_gas_station;
      case 'Taxes':
        return Icons.account_balance;
      case 'Maintenance':
        return Icons.build;
      case 'Gifts':
        return Icons.card_giftcard;
      case 'Hobbies':
        return Icons.piano;
      case 'Cookie':
        return Icons.cookie;
      default:
        return Icons.category;
    }
  }

  static Color getColorForCategory(String category) {
    switch (category) {
      case 'Food':
        return Colors.yellowAccent;
      case 'Transport':
        return Colors.blueAccent;
      case 'Health':
        return Colors.greenAccent;
      case 'Leisure':
        return Colors.orangeAccent;
      case 'Housing':
        return Colors.purpleAccent;
      case 'Education':
        return Colors.pinkAccent;
      case 'Clothing':
        return Colors.cyan;
      case 'Fast Food':
        return Colors.amber;
      case 'Supermarket':
        return Colors.lime;
      case 'Pets':
        return Colors.cyan;
      case 'Technology':
        return Colors.blueAccent;
      case 'Appliances':
        return Colors.cyan;
      case 'Travel':
        return Colors.lightBlueAccent;
      case 'Savings':
        return Colors.lightGreen;
      case 'Entertainment':
        return Colors.amber;
      case 'Sports':
        return Colors.lime;
      case 'Beauty':
        return Colors.purpleAccent;
      case 'Restaurants':
        return Colors.orangeAccent;
      case 'Drinks':
        return Colors.orangeAccent;
      case 'Coffee':
        return Colors.brown;
      case 'Services':
        return Colors.lightBlue;
      case 'Telephony':
        return Colors.lightGreen;
      case 'Internet':
        return Colors.yellowAccent;
      case 'Electricity':
        return Colors.yellowAccent;
      case 'Water':
        return Colors.lightBlueAccent;
      case 'Gasoline':
        return Colors.blueAccent;
      case 'Taxes':
        return Colors.greenAccent;
      case 'Maintenance':
        return Colors.cyanAccent;
      case 'Gifts':
        return Colors.redAccent;
      case 'Hobbies':
        return Colors.pinkAccent;
      case 'Cookie':
        return Colors.orangeAccent;
      default:
        return Colors.blueGrey;
    }
  }

  void _generateBubbles() {
    bubbles = List<Bubble>.generate(150, (index) {
      final size = math.Random().nextInt(25) + 10.0;
      final speed = math.Random().nextInt(50) + 1.0;
      final directionRandom = math.Random().nextBool();
      final direction =
          math.Random().nextInt(500) * (directionRandom ? 1.0 : -1.0);

      final categories = [
        'Food',
        'Transport',
        'Health',
        'Leisure',
        'Housing',
        'Education',
        'Clothing',
        'Fast Food',
        'Supermarket',
        'Pets',
        'Technology',
        'Appliances',
        'Travel',
        'Savings',
        'Entertainment',
        'Sports',
        'Beauty',
        'Restaurants',
        'Drinks',
        'Coffee',
        'Services',
        'Telephony',
        'Internet',
        'Electricity',
        'Water',
        'Gasoline',
        'Taxes',
        'Maintenance',
        'Gifts',
        'Hobbies',
        'Cookie',
      ];
      final category = categories[math.Random().nextInt(categories.length)];
      //final iconColor = getColorForCategory(category);
      final icon = getIconForCategory(category);
      final colorRandom = math.Random().nextBool();
      final color = colorRandom ? logoCOLOR1 : logoCOLOR2.withOpacity(0.5);

      return Bubble(
        color: color,
        iconColor: Colors.black,
        direction: direction,
        speed: speed,
        size: size,
        initialPosition: index * 10.0,
        icon: icon,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: Listenable.merge(
          [
            progressAnimation,
            cloudOutAnimation,
            bubblesAnimation,
          ],
        ),
        builder: (context, snapshot) {
          final size = queryData.width * 0.5;
          final circleSize = size *
              math.pow(
                  (progressAnimation.value + cloudOutAnimation.value + 1), 2);
          final topPosition = queryData.height * 0.0;
          final centerMargin = queryData.width - circleSize;
          final leftSize =
              size * 0.0 * math.pow((1 - progressAnimation.value), 3);
          final rightSize =
              size * 0.0 * math.pow((1 - progressAnimation.value), 3);
          final leftMargin = queryData.width / 2 - leftSize * 1.2;
          final rightMargin = queryData.width / 2 - rightSize * 1.2;
          final middleMargin = queryData.width / 2 -
              (size / 2) * math.pow((1 - progressAnimation.value), 3);
          final topOutPosition = queryData.height * cloudOutAnimation.value;
          final bottomMiddleSize =
              size * math.pow((1 - progressAnimation.value), 3);

          return Positioned(
            left: 0,
            right: 0,
            top: topPosition - circleSize + topOutPosition,
            height: circleSize,
            child: Stack(
              children: [
                Positioned(
                  height: leftSize / 2,
                  width: bottomMiddleSize,
                  left: middleMargin,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  height: leftSize,
                  width: leftSize,
                  left: leftMargin,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  height: rightSize,
                  width: rightSize,
                  right: rightMargin,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  height: circleSize,
                  width: circleSize,
                  bottom: 0,
                  left: centerMargin / 2,
                  child: ClipOval(
                    child: CustomPaint(
                      foregroundPainter: _CloudBubblePainter(
                        bubblesAnimation,
                        bubbles,
                      ),
                      child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                        colors: [darkCardBackground, darkCardBackground],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ))),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _CloudBubblePainter extends CustomPainter {
  _CloudBubblePainter(
    this.animation,
    this.bubbles,
  ) : super(repaint: animation);

  final Animation<double> animation;
  final List<Bubble> bubbles;

  @override
  void paint(Canvas canvas, Size size) {
    for (Bubble bubble in bubbles) {
      final offset = Offset(
        size.width / 2 + bubble.direction * animation.value,
        size.height * 1.2 * (1 - animation.value) -
            bubble.speed * animation.value +
            bubble.initialPosition * (1 - animation.value),
      );

      // Draw circle
      canvas.drawCircle(offset, bubble.size, Paint()..color = bubble.color);

      // Draw icon
      /*  final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(bubble.icon.codePoint),
          style: TextStyle(
            fontSize: bubble.size * 1.2,
            fontFamily: bubble.icon.fontFamily,
            color: bubble.iconColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      ); */
      /*  iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          offset.dx - iconPainter.width / 2,
          offset.dy - iconPainter.height / 2,
        ),
      ); */
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
