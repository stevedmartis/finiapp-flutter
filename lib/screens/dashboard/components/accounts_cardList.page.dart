import 'package:finia_app/screens/credit_card/account_cards_widget.dart';
import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/screens/dashboard/dashboard_home.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:flutter/material.dart';

class AccountsCardHorizontalList extends StatefulWidget {
  final List<AccountWithSummary> accounts;

  const AccountsCardHorizontalList({super.key, required this.accounts});

  @override
  State<AccountsCardHorizontalList> createState() =>
      _CreditCardHorizontalListState();
}

class _CreditCardHorizontalListState extends State<AccountsCardHorizontalList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: ClipRect(
          child: Row(
            children: widget.accounts.asMap().entries.map((entry) {
              int index = entry.key; // Get the index here
              AccountWithSummary card = entry.value;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _handleCardTap(context, card, index);
                  },
                  child: Hero(
                      tag: 'cardsHome-${card.account.name}',
                      child: AccountCard(accountSumarry: card)),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(
      BuildContext context, AccountWithSummary card, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetail(accountSummary: card),
      ),
    );
  }
}
