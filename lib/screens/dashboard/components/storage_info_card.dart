import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class AmmountsInfoCard extends StatelessWidget {
  const AmmountsInfoCard({
    super.key,
    required transactionId,
    required this.title,
    required this.svgSrc,
    required this.amount,
    required this.currency,
    this.date,
  });

  final Widget svgSrc;
  final String title, currency;
  final double amount;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: Colors.transparent,
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: svgSrc,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatCurrency(amount),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: themeProvider.getSubtitleColor()),
                  ),
                  if (date !=
                      null) // Opcional, muestra la fecha si está disponible
                    Text(
                      DateFormat('yyyy-MM-dd', 'es_ES').format(date!),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: themeProvider.getSubtitleColor()),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
