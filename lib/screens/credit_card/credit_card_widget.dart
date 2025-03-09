import 'package:auto_size_text/auto_size_text.dart';
import 'package:finia_app/models/my_files.dart';
import 'package:finia_app/models/transaction.model.dart';
import 'package:finia_app/screens/credit_card/card_company.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_background.dart';
import 'card_network_type.dart';
import 'validity.dart';

class CreditCard extends StatefulWidget {
  final CardBackground cardBackground;
  final CardNetworkType? cardNetworkType;
  final CardCompany? company;
  final String? cardHolderName;
  final String? cardNumber;
  final double roundedCornerRadius;
  final Validity? validity;
  final Color numberColor;
  final Color validityColor;
  final Color cardHolderNameColor;
  final bool showChip;
  final String? currency;
  final double total;
  final double used;
  final double available;
  final bool delay;
  final List<CloudStorageInfo> fileInfo;
  final List<TransactionCreditCard> transactions;

  const CreditCard({
    super.key,
    required this.cardBackground,
    this.cardNetworkType,
    this.cardNumber,
    this.cardHolderName,
    this.company,
    this.validity,
    this.roundedCornerRadius = 20,
    this.numberColor = Colors.white,
    this.validityColor = Colors.white,
    this.cardHolderNameColor = Colors.white,
    this.showChip = true,
    this.currency = 'CLP',
    this.total = 10.000,
    this.used = 6,
    this.available = 5.000,
    this.delay = false,
    required this.fileInfo,
    required this.transactions,
  });

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool _isDataLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    loadData();
  }

  void loadData() async {
    await Future.delayed(
        const Duration(milliseconds: 100)); // Simulate data loading
    if (mounted) {
      setState(() {
        _isDataLoading = false;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 180,
      decoration: _buildGlassBackground(themeProvider),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.showChip) _buildChip(),
              if (widget.company != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: widget.company!.widget,
                ),
            ],
          ),
          _isDataLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildCardNumber(themeProvider),
                      const SizedBox(height: 10),
                      _buildValidity(themeProvider),
                      const SizedBox(height: 10),
                      _buildNameAndCardNetworkType(themeProvider),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  BoxDecoration _buildGlassBackground(ThemeProvider themeProvider) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
      gradient: themeProvider.getGradientCard(),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildChip() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/cards/chip.png',
        height: 25,
      ),
    );
  }

  Widget _buildCardNumber(ThemeProvider themeProvider) {
    if (widget.cardNumber == null || widget.cardNumber!.trim() == "") {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.cardNumber!,
        style: TextStyle(
          fontFamily: 'creditcard',
          color: themeProvider.getSubtitleColor(),
          fontSize: 18,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildValidity(ThemeProvider themeProvider) {
    if (widget.validity == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'VALID FROM',
              style: TextStyle(
                color: themeProvider.getSubtitleColor(),
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.validity!.validThruMonth.toString().padLeft(2, '0')}/${widget.validity!.validThruYear.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: themeProvider.getSubtitleColor(),
                fontSize: 12,
                fontFamily: 'creditcard',
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'VALID THRU',
              style: TextStyle(
                color: themeProvider.getSubtitleColor(),
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.validity!.validThruMonth.toString().padLeft(2, '0')}/${widget.validity!.validThruYear.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: themeProvider.getSubtitleColor(),
                fontSize: 12,
                fontFamily: 'creditcard',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNameAndCardNetworkType(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (widget.cardHolderName != null)
          Expanded(
            flex: 3,
            child: AutoSizeText(
              widget.cardHolderName!.toUpperCase(),
              maxLines: 1,
              minFontSize: 10,
              style: TextStyle(
                fontFamily: 'creditcard',
                color: themeProvider.getSubtitleColor(),
                fontSize: 14,
              ),
            ),
          ),
        if (widget.cardNetworkType != null)
          Align(
            alignment: Alignment.centerRight,
            child: widget.cardNetworkType!.widget,
          ),
      ],
    );
  }
}
