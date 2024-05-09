import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

class AmmountsInfoCard extends StatelessWidget {
  const AmmountsInfoCard({
    String? key,
    required this.title,
    required this.svgSrc,
    required this.amount,
    required this.currency,
    this.date,
  });

  final Widget svgSrc;
  final String title, amount, currency;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    amount + " " + currency,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white70),
                  ),
                  if (date !=
                      null) // Opcional, muestra la fecha si está disponible
                    Text(
                      DateFormat('yyyy-MM-dd', 'es_ES').format(date!),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white70),
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
