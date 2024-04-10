import 'package:flutter/material.dart';
import 'package:finia_app/screens/dashboard/dashboard_screen.dart';
import 'package:finia_app/controllers/MenuAppController.dart'; // Asegúrate de importar MenuAppController
import 'components/side_menu.dart';
import 'package:provider/provider.dart'; // Importa provider

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accede a MenuAppController desde el contexto
    final menuAppController =
        Provider.of<MenuAppController>(context, listen: false);

    return Scaffold(
      key: menuAppController
          .scaffoldKey, // Asigna la GlobalKey del Scaffold aquí
      drawer: SideMenu(), // Define tu drawer aquí
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (MediaQuery.of(context).size.width > 600)
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
