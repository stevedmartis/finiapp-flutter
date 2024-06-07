import 'package:auto_size_text/auto_size_text.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/models/MyFiles.dart';
import 'package:finia_app/models/transaction.model.dart';
import 'package:finia_app/screens/credit_card/card_company.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_background.dart';
import 'card_network_type.dart';
import 'validity.dart';

List<TransactionCreditCard> myTransactions = [
  TransactionCreditCard(
      id: '0',
      date: DateTime.now(),
      description: "Compra Galletas",
      inAmount: 0,
      outAmount: 50000,
      currency: "CLP",
      icon: Icon(Icons.cookie, color: Color.fromARGB(255, 253, 127, 0))),
  TransactionCreditCard(
      id: '1',
      date: DateTime.now(),
      description: "Compra en Supermercado",
      inAmount: 0,
      outAmount: 50000,
      currency: "CLP",
      icon: Icon(Icons.store, color: Color.fromARGB(255, 0, 162, 238))),
  TransactionCreditCard(
      id: '2',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: "Compra en Librería",
      inAmount: 0,
      outAmount: 30000,
      currency: "CLP",
      icon: Icon(Icons.book, color: Color.fromARGB(255, 250, 0, 0))),
  TransactionCreditCard(
      id: '3',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: "Compra en Librería",
      inAmount: 0,
      outAmount: 30000,
      currency: "CLP",
      icon: Icon(Icons.book, color: Color.fromARGB(255, 253, 127, 0))),
  TransactionCreditCard(
      id: '4',
      date: DateTime.now().subtract(Duration(days: 3)),
      description: "Compra Galletas",
      inAmount: 0,
      outAmount: 50000,
      currency: "CLP",
      icon: Icon(Icons.cookie, color: Color.fromARGB(255, 253, 127, 0))),
  // Agrega más transacciones según necesites
];

List<CreditCard> myProducts = [
  CreditCard(
      fileInfo: [
        CloudStorageInfo(
          title: "Ingresado:",
          numOfFiles: 1328,
          icon: Icon(
            Icons.account_balance,
            color: Colors.blue,
            size: 20,
          ),
          totalStorage: "\$1.9",
          color: primaryColor,
          percentage: 50,
        ),
        CloudStorageInfo(
          title: "Gastado",
          numOfFiles: 1328,
          icon: Icon(
            Icons.credit_card,
            color: Color(0xFFFFA113),
            size: 20,
          ),
          totalStorage: "\$2.9",
          color: Color(0xFFFFA113),
          percentage: 35,
        ),
      ],
      transactions: myTransactions,
      cardBackground: GradientCardBackground(
        LinearGradient(
          colors: [
            const Color.fromARGB(255, 60, 78, 87),
            const Color.fromARGB(255, 45, 58, 65)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      cardNumber: '2345 5678 4565 8765',
      cardHolderName: 'John Doe',
      validity: Validity(validThruMonth: 12, validThruYear: 25),
      total: 250000,
      used: 200000,
      available: 130000,
      delay: true,
      company: CardCompany(Image.asset(
        'assets/images/cards/visa.jpeg',
        height: 40,
      ))),
  CreditCard(
      fileInfo: [
        CloudStorageInfo(
          title: "Ingresado:",
          numOfFiles: 1328,
          icon: Icon(Icons.account_balance, color: Colors.blue, size: 20),
          totalStorage: "\$1.9",
          color: primaryColor,
          percentage: 50,
        ),
        CloudStorageInfo(
          title: "Gastado",
          numOfFiles: 1328,
          icon: Icon(Icons.credit_card, color: Color(0xFFFFA113), size: 20),
          totalStorage: "\$2.9",
          color: Color(0xFFFFA113),
          percentage: 35,
        ),
      ],
      transactions: myTransactions,
      cardBackground: GradientCardBackground(
        LinearGradient(
          colors: [
            const Color.fromARGB(255, 60, 78, 87),
            const Color.fromARGB(255, 45, 58, 65)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      cardNumber: '3456 7896 7896 5678',
      cardHolderName: 'Jane Doe',
      validity: Validity(validThruMonth: 11, validThruYear: 24),
      total: 150000,
      used: 300000,
      available: 5,
      delay: true,
      company: CardCompany(Image.asset(
        'assets/images/cards/mastercard.png',
        height: 40,
      ))),
  CreditCard(
      fileInfo: [
        CloudStorageInfo(
          title: "Ingresado:",
          numOfFiles: 1328,
          icon: Icon(
            Icons.account_balance,
            color: Colors.blue,
            size: 20,
          ),
          totalStorage: "\$1.9",
          color: primaryColor,
          percentage: 50,
        ),
        CloudStorageInfo(
          title: "Gastado",
          numOfFiles: 1328,
          icon: Icon(
            Icons.credit_card,
            color: Color(0xFFFFA113),
            size: 20,
          ),
          totalStorage: "\$2.9",
          color: Color(0xFFFFA113),
          percentage: 35,
        ),
      ],
      transactions: myTransactions,
      cardBackground: GradientCardBackground(
        LinearGradient(
          colors: [
            const Color.fromARGB(255, 60, 78, 87),
            const Color.fromARGB(255, 45, 58, 65)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      cardNumber: '1234 5678 9012 3456',
      cardHolderName: 'John Doe',
      validity: Validity(validThruMonth: 12, validThruYear: 25),
      total: 40000,
      used: 18000,
      available: 2,
      delay: true,
      company: CardCompany(Image.asset(
        'assets/images/cards/mastercard.png',
        height: 40,
      ))),
];

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: 350,
          height: 200, // Ajusta la altura para la tarjeta de crédito
          decoration: _buildBackground(themeProvider),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : FadeTransition(
                      opacity: _opacityAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildCardNumber(themeProvider),
                          SizedBox(height: 10),
                          _buildValidity(themeProvider),
                          SizedBox(height: 10),
                          _buildNameAndCardNetworkType(themeProvider),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        _buildCurrentBalance(
            themeProvider), // Añadido el saldo actual fuera de la tarjeta
      ],
    );
  }

  BoxDecoration _buildBackground(ThemeProvider themeProvider) {
    BoxDecoration decoration;

    if (widget.cardBackground is SolidColorCardBackground) {
      SolidColorCardBackground solidColorCardBackground =
          widget.cardBackground as SolidColorCardBackground;
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        color: solidColorCardBackground.backgroundColor,
      );
    } else if (widget.cardBackground is GradientCardBackground) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        gradient: themeProvider.getGradientCard(),
      );
    } else if (widget.cardBackground is ImageCardBackground) {
      ImageCardBackground imageCardBackground =
          widget.cardBackground as ImageCardBackground;
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        image: imageCardBackground.build(),
      );
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        color: Colors.black,
      );
    }

    return decoration.copyWith(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  Widget _buildChip() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/cards/chip.png',
        height: 25,
      ),
    );
  }

  Widget _buildCardNumber(ThemeProvider themeProvider) {
    if (widget.cardNumber == null || widget.cardNumber!.trim() == "") {
      return SizedBox.shrink();
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
      return SizedBox.shrink();
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
            SizedBox(height: 2),
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
            SizedBox(height: 2),
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

  Widget _buildCurrentBalance(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo Total',
            style: TextStyle(
              fontSize: defaultSubTitle,
              fontWeight: FontWeight.bold,
              color: themeProvider.getSubtitleColor(),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: themeProvider.getGradientCard(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: logoCOLOR1,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      formatCurrency(widget.available),
                      style: TextStyle(
                        color: themeProvider.getSubtitleColor(),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward,
                  color: logoCOLOR1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
