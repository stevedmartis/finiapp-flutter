import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  final MenuAppController menuAppController;

  MainScreen({required this.menuAppController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: menuAppController.scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
