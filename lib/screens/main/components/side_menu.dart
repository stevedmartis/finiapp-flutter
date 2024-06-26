import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {},
              themeNotifier: themeNotifier),
          DrawerListTile(
              title: "Credit Cards",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                var authService =
                    Provider.of<AuthService>(context, listen: false);
                authService.cardsHero = 'cardsMenu';
                Navigator.pushNamed(context, '/cards');
              },
              themeNotifier: themeNotifier),
          DrawerListTile(
              title: "Notification",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {},
              themeNotifier: themeNotifier),
          DrawerListTile(
              title: "Profile",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {},
              themeNotifier: themeNotifier),
          DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {},
              themeNotifier: themeNotifier),
          DrawerListTile(
              title: "SignOut",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () async {
                await context.read<AuthService>().signOut();
                Navigator.of(context).pushReplacementNamed('/signIn');
              },
              themeNotifier: themeNotifier),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                    themeNotifier.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: logoCOLOR1),
                Switch(
                  value: themeNotifier.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeNotifier.toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      // For selecting those three lines once press "Command+D"
      required this.title,
      required this.svgSrc,
      required this.press,
      required this.themeNotifier})
      : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final ThemeProvider themeNotifier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter:
            ColorFilter.mode(themeNotifier.getTitleColor(), BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: themeNotifier.getSubtitleColor()),
      ),
    );
  }
}
