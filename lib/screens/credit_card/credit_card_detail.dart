import 'package:finia_app/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/dashboard/components/transactions_list.page.dart';
import 'package:finia_app/services/auth_service.dart';
import 'credit_card_widget.dart';

class CreditCardDetail extends StatefulWidget {
  final CreditCard card;

  const CreditCardDetail({Key? key, required this.card}) : super(key: key);

  @override
  _CreditCardDetailState createState() => _CreditCardDetailState();
}

class _CreditCardDetailState extends State<CreditCardDetail> {
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);
    var tagActual = authService.cardsHero;
    final heroTag = '${tagActual}-${widget.card.cardNumber}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Detail'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Hero(
                tag: heroTag,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: widget.card,
                ), // El Hero widget no tiene padding adicional.
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: defaultPadding),
                    InfoCardsAmounts(
                      fileInfo: widget.card.fileInfo,
                    ),

                    Text(
                      textAlign: TextAlign.center,
                      'Total: \$${widget.card.total}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //  InfoCardsAmounts(files: demoMyFiles),
                    SizedBox(height: defaultPadding),
                    // Agrega más widgets si necesitas aquí, cada uno tendrá el padding horizontal.
                    if (Responsive.isMobile(context))
                      TransactionHistorialPage(),
                  ],
                ),
              ),
            ),

            // Agregar más Slivers si es necesario
          ],
        ),
      ),
    );
  }
}
