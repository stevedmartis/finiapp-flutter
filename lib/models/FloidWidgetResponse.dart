class FloidWidgetResponse {
  String consumerId;
  String caseid;
  Products products;
  Transactions transactions;
  Income income;

  FloidWidgetResponse({
    required this.consumerId,
    required this.caseid,
    required this.products,
    required this.transactions,
    required this.income,
  });
}

class Income {
  List<IncomeAccount> accounts;

  Income({
    required this.accounts,
  });
}

class IncomeAccount {
  int accountNumber;
  String regularity;
  int totalAverage;
  int mainAverage;
  int extraAverage;
  String mainIncomeDeposit;
  List<IncomeByMonth> incomeByMonth;

  IncomeAccount({
    required this.accountNumber,
    required this.regularity,
    required this.totalAverage,
    required this.mainAverage,
    required this.extraAverage,
    required this.mainIncomeDeposit,
    required this.incomeByMonth,
  });
}

class IncomeByMonth {
  String month;
  int total;
  int main;
  int extra;
  DateTime date;
  List<Source> sources;

  IncomeByMonth({
    required this.month,
    required this.total,
    required this.main,
    required this.extra,
    required this.date,
    required this.sources,
  });
}

class Source {
  Sender sender;
  int amount;
  Type type;

  Source({
    required this.sender,
    required this.amount,
    required this.type,
  });
}

enum Sender {
  ABONO_DE_CREDITO_29600179865,
  ABONO_POR_TRF_DESDE_OTRO_BANCO_EN_LINEA,
  ABONO_TERCEROS_123456780_A_PEREZ_BAR,
  TRANSFER_DE_FLOW_SPA,
  TRANSFER_DE_PEREZ
}

enum Type { EXTRA, MAIN }

class Products {
  List<ProductsAccount> accounts;
  List<Card> cards;
  List<Line> lines;

  Products({
    required this.accounts,
    required this.cards,
    required this.lines,
  });
}

class ProductsAccount {
  String type;
  int number;
  String currency;
  int balance;

  ProductsAccount({
    required this.type,
    required this.number,
    required this.currency,
    required this.balance,
  });
}

class Card {
  String number;
  String currency;
  int total;
  int used;
  int available;
  String name;

  Card({
    required this.number,
    required this.currency,
    required this.total,
    required this.used,
    required this.available,
    required this.name,
  });
}

class Line {
  int number;
  String currency;
  int total;
  int used;
  int available;

  Line({
    required this.number,
    required this.currency,
    required this.total,
    required this.used,
    required this.available,
  });
}

class Transactions {
  List<TransactionsAccount> accounts;

  Transactions({
    required this.accounts,
  });
}

class TransactionsAccount {
  int accountNumber;
  List<Transaction> transactions;

  TransactionsAccount({
    required this.accountNumber,
    required this.transactions,
  });
}

class Transaction {
  DateTime date;
  Branch branch;
  String description;
  String docNumber;
  int out;
  int transactionIn;
  int balance;
  String id;

  Transaction({
    required this.date,
    required this.branch,
    required this.description,
    required this.docNumber,
    required this.out,
    required this.transactionIn,
    required this.balance,
    required this.id,
  });
}

enum Branch { EMPTY, OF_CENTRA, PREFISIDO }
