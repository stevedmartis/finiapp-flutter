/* import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart'; */
import 'package:finia_app/screens/dashboard/dash4.beta.dart';
import 'package:finia_app/screens/dashboard/dash4scroll.dart';
import 'package:finia_app/screens/dashboard/dashboard4.dart';
import 'package:finia_app/screens/dashscreenbeta2.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'components/side_menu.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      drawer: SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > 600)
            Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: AdvancedScrollView(),
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
