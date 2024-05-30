import 'package:auto_size_text/auto_size_text.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/models/MyFiles.dart';
import 'package:finia_app/models/transaction.model.dart';
import 'package:finia_app/screens/credit_card/card_company.dart';
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
      available: 10,
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 300,
      height: 200,
      decoration: _buildBackground(),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.showChip) _buildChip(),
              if (widget.company != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: widget.company!.widget,
                ),
            ],
          ),
          _isDataLoading
              ? Center(
                  child: SizedBox(height: 4),
                )
              : FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: <Widget>[
                      _buildCardNumber(),
                      SizedBox(height: 4),
                      _buildValidity(),
                      SizedBox(height: 4),
                      _buildNameAndCardNetworkType(),
                    ],
                  ),
                ),
          // Construir los widgets una vez los datos estén listos
        ],
      ),
    );
  }

  BoxDecoration _buildBackground() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (widget.cardBackground is SolidColorCardBackground) {
      SolidColorCardBackground solidColorCardBackground =
          widget.cardBackground as SolidColorCardBackground;
      return BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        color: solidColorCardBackground.backgroundColor,
      );
    } else if (widget.cardBackground is GradientCardBackground) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        gradient: themeProvider.getGradientCard(),
      );
    } else if (widget.cardBackground is ImageCardBackground) {
      ImageCardBackground imageCardBackground =
          widget.cardBackground as ImageCardBackground;
      return BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        image: imageCardBackground.build(),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedCornerRadius),
        color: Colors.black,
      );
    }
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

  Widget _buildCardNumber() {
    if (widget.cardNumber == null || widget.cardNumber!.trim() == "") {
      return SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.cardNumber!,
        style: TextStyle(
          fontFamily: 'creditcard',
          color: widget.numberColor,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildValidity() {
    if (widget.validity == null) {
      return SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'VALID FROM',
              style: TextStyle(
                color: widget.validityColor,
                fontSize: 8,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${widget.validity!.validThruMonth.toString().padLeft(2, '0')}/${widget.validity!.validThruYear.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: widget.validityColor,
                fontSize: 10,
                fontFamily: 'creditcard',
              ),
            ),
          ],
        ),
        SizedBox(width: 24),
        Column(
          children: <Widget>[
            Text(
              'VALID THRU',
              style: TextStyle(
                color: widget.validityColor,
                fontSize: 8,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${widget.validity!.validThruMonth.toString().padLeft(2, '0')}/${widget.validity!.validThruYear.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: widget.validityColor,
                fontSize: 10,
                fontFamily: 'creditcard',
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildNameAndCardNetworkType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (widget.cardHolderName != null)
          Expanded(
            flex: 3,
            child: AutoSizeText(
              widget.cardHolderName!.toUpperCase(),
              maxLines: 1,
              minFontSize: 8,
              style: TextStyle(
                fontFamily: 'creditcard',
                color: widget.cardHolderNameColor,
              ),
            ),
          ),
        SizedBox(width: 16),
        Expanded(
          child: _buildCardNetworkType(),
        ),
      ],
    );
  }

  Widget _buildCardNetworkType() {
    if (widget.cardNetworkType == null) {
      return SizedBox.shrink();
    }
    return widget.cardNetworkType!.widget;
  }
}
