import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:finia_app/helper/colors.dart';
import 'package:provider/provider.dart';

class SocialButton extends StatelessWidget {
  final String name;
  final String icon;
  final bool appleLogo;
  final VoidCallback? onPressed;

  const SocialButton(
      {super.key,
      required this.name,
      required this.icon,
      this.appleLogo = false,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              width: 0.1,
              color: Colors.white,
              style: BorderStyle.solid,
            ),
          ),
          backgroundColor: themeProvider.getCardColor(),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appleLogo
              ? SvgPicture.asset(
                  icon,
                  height: 30.0,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                )
              : SvgPicture.asset(
                  icon,
                  height: 30.0,
                ),
          const SizedBox(
            width: 16.0,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: themeProvider.getSubtitleColor()),
          )
        ],
      ),
    );
  }
}
