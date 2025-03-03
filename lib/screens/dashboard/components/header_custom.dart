import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';

Widget buildHeaderContent(BuildContext context, ThemeProvider themeProvider) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          formatCurrency(1842081),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildIndicator(
              icon: Icons.arrow_upward,
              title: 'Ingresado',
              amount: 12000,
              context: context,
              isPositive: true,
              themeProvider: themeProvider,
            ),
            const SizedBox(width: 16),
            buildIndicator(
              icon: Icons.arrow_downward,
              title: 'Gastado',
              amount: 6000,
              context: context,
              isPositive: false,
              themeProvider: themeProvider,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildIndicator({
  required IconData icon,
  required String title,
  required double amount,
  required BuildContext context,
  required bool isPositive,
  required ThemeProvider themeProvider,
}) {
  return Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: themeProvider.getBackgroundColor(),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: isPositive ? Colors.green : Colors.red,
              size: 30,
            ),
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  formatCurrency(amount),
                  style: TextStyle(
                    fontSize: 20,
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}

String formatCurrency(double amount) {
  final NumberFormat format =
      NumberFormat.currency(locale: 'es_CL', symbol: '');
  String formatted = format.format(amount);
  formatted = formatted
      .replaceAll('\$', '')
      .replaceAll(',', ''); // Eliminar símbolo y separador de miles
  return '\$$formatted'.substring(0, formatted.length - 2);
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final String title;
  final bool showLeading;
  final bool showActions;
  final VoidCallback onLeadingPressed;
  final VoidCallback onActionPressed;
  final ThemeProvider themeProvider;
  final Widget child;

  SliverCustomHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.title,
    this.showLeading = true,
    this.showActions = true,
    required this.onLeadingPressed,
    required this.onActionPressed,
    required this.themeProvider,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double proportion = (maxHeight - shrinkOffset) / maxHeight;
    final double opacity = proportion.clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment.bottomCenter,
              colors: [
                logoCOLOR1,
                logoCOLOR2,
              ],
            ),
          ),
        ),
        Positioned(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showLeading)
                  GestureDetector(
                    onTap: onLeadingPressed,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.chevron_left,
                        color: themeProvider.getBackgroundColor(),
                      ),
                    ),
                  ),
                if (showActions)
                  GestureDetector(
                    onTap: onActionPressed,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.notifications,
                        color: themeProvider.getBackgroundColor(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
