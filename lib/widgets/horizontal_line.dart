import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key, required this.name, required this.height});

  final String name;
  final double height;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: themeProvider.getSubtitleColor().withOpacity(0.5),
              height: height,
              thickness: 4.0,
            ),
          ),
        ),
        Text(name),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: themeProvider.getSubtitleColor().withOpacity(0.5),
              height: height,
              thickness: 4.0,
            ),
          ),
        ),
      ],
    );
  }
}
