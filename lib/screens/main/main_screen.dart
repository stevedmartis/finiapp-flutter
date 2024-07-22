/* import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart'; */
import 'package:finia_app/screens/dashboard/dashboard_home.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'components/side_menu.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();

  const MainScreen({super.key});
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
/*       final authProvider = Provider.of<AuthService>(context, listen: false);
      if (Provider.of<FinancialDataService>(context, listen: false)
              .financialData ==
          null) {
        Provider.of<FinancialDataService>(context, listen: false)
            .fetchFinancialSummary(authProvider.currentUser!.userId!);
      } */
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuAppController =
        Provider.of<MenuAppController>(context, listen: false);

    return Scaffold(
      key: menuAppController.scaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > 600)
            const Expanded(
              child: SideMenu(),
            ),
          const Expanded(
            flex: 5,
            child: DashBoardHomeScreen(),
          ),
          /*             Expanded(
            flex: 5,
            child: Consumer<FinancialDataService>(
              builder: (context, financialDataService, _) {
                final financialData = financialDataService.financialData;
                if (financialData != null) {
                  // Aquí puedes utilizar los datos financieros para construir la interfaz de usuario
                  return Text('${financialData.creditcards[0].name}');
                } else {
                  // Muestra un indicador de carga u otra interfaz mientras se cargan los datos
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ), */
        ],
      ),
    );
  }
}
