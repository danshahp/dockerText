class DailySales {
  final String weekday;
  final double cashSales;
  final double creditSales;

  DailySales({
    required this.weekday,
    required this.cashSales,
    required this.creditSales,
  });

  double get totalSales => cashSales + creditSales;
}

class WeeklySales {
  final List<DailySales> days;

  WeeklySales({required this.days});

  double get totalCashSales =>
      days.fold(0.0, (sum, day) => sum + day.cashSales);

  double get totalCreditSales =>
      days.fold(0.0, (sum, day) => sum + day.creditSales);

  double get totalSales => days.fold(0.0, (sum, day) => sum + day.totalSales);
}

class DailyBusinessSummary {
  final double todaysCashSales;
  final double todaysCashProfit;
  final double todaysExpenditure;
  final double todaysCreditSales;
  final double todaysCreditExpectedProfit;
  final int itemsOutOfStock;
  final int itemsExpiredOrAboutToExpire;
  final int overdueInvoices;
  final double todaysAdvancePayments;
  final double todaysInvoicePayments;
  final double todaysSupplierBillPayments;
  final double totalCashInHand;

  DailyBusinessSummary({
    required this.todaysCashSales,
    required this.todaysCashProfit,
    required this.todaysExpenditure,
    required this.todaysCreditSales,
    required this.todaysCreditExpectedProfit,
    required this.itemsOutOfStock,
    required this.itemsExpiredOrAboutToExpire,
    required this.overdueInvoices,
    required this.todaysAdvancePayments,
    required this.todaysInvoicePayments,
    required this.todaysSupplierBillPayments,
    required this.totalCashInHand,
  });

  static List<String> get titles => [
    "Today's Cash Sales",
    "Today's Profit (From Cash Sales)",
    "Today's Expenditure",
    "Today's Credit Sales",
    "Today's Credit Sales Expected Profit",
    "Items Out of Stock",
    "Items Expired/ About To Expire",
    "Overdue Invoices (Debts)",
    "Today's Advance Payments",
    "Today's Invoice Payments",
    "Today's Suppliers Bill Payments",
    "Total Today's Cash in Hand",
  ];

  factory DailyBusinessSummary.fromMap(Map<String, dynamic> map) {
    return DailyBusinessSummary(
      todaysCashSales: map['todaysCashSales']?.toDouble() ?? 0.0,
      todaysCashProfit: map['todaysCashProfit']?.toDouble() ?? 0.0,
      todaysExpenditure: map['todaysExpenditure']?.toDouble() ?? 0.0,
      todaysCreditSales: map['todaysCreditSales']?.toDouble() ?? 0.0,
      todaysCreditExpectedProfit:
          map['todaysCreditExpectedProfit']?.toDouble() ?? 0.0,
      itemsOutOfStock: map['itemsOutOfStock'] ?? 0,
      itemsExpiredOrAboutToExpire: map['itemsExpiredOrAboutToExpire'] ?? 0,
      overdueInvoices: map['overdueInvoices'] ?? 0,
      todaysAdvancePayments: map['todaysAdvancePayments']?.toDouble() ?? 0.0,
      todaysInvoicePayments: map['todaysInvoicePayments']?.toDouble() ?? 0.0,
      todaysSupplierBillPayments:
          map['todaysSupplierBillPayments']?.toDouble() ?? 0.0,
      totalCashInHand: map['totalCashInHand']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todaysCashSales': todaysCashSales,
      'todaysCashProfit': todaysCashProfit,
      'todaysExpenditure': todaysExpenditure,
      'todaysCreditSales': todaysCreditSales,
      'todaysCreditExpectedProfit': todaysCreditExpectedProfit,
      'itemsOutOfStock': itemsOutOfStock,
      'itemsExpiredOrAboutToExpire': itemsExpiredOrAboutToExpire,
      'overdueInvoices': overdueInvoices,
      'todaysAdvancePayments': todaysAdvancePayments,
      'todaysInvoicePayments': todaysInvoicePayments,
      'todaysSupplierBillPayments': todaysSupplierBillPayments,
      'totalCashInHand': totalCashInHand,
    };
  }
}

class MonthlyFinancialSummary {
  final List<double> cashSales; // Index 0 = Jan, 11 = Dec
  final List<double> creditSales; // Index 0 = Jan, 11 = Dec
  final List<double> costOfGoodsSold; // Index 0 = Jan, 11 = Dec
  final List<double> expenditures; // Index 0 = Jan, 11 = Dec

  MonthlyFinancialSummary({
    required this.cashSales,
    required this.creditSales,
    required this.costOfGoodsSold,
    required this.expenditures,
  }) {
    // Ensure all lists have 12 months
    if ([
      cashSales,
      creditSales,
      costOfGoodsSold,
      expenditures,
    ].any((list) => list.length != 12)) {
      throw ArgumentError(
        'All input lists must have exactly 12 elements (one for each month).',
      );
    }
  }

  static const List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  // cash plus credit
  List<double> get cashPlusCredit =>
      List.generate(12, (i) => cashSales[i] + creditSales[i]);

  /// Gross Profit = (Cash + Credit Sales) - COGS
  List<double> get grossProfits => List.generate(
    12,
    (i) => (cashSales[i] + creditSales[i]) - costOfGoodsSold[i],
  );

  /// Net Worth = Gross Profit - Expenditures
  List<double> get netWorths =>
      List.generate(12, (i) => grossProfits[i] - expenditures[i]);

  double get totalCashSales => cashSales.fold(0.0, (sum, value) => sum + value);

  double get totalCreditSales =>
      creditSales.fold(0.0, (sum, value) => sum + value);

  double get totalCOGS =>
      costOfGoodsSold.fold(0.0, (sum, value) => sum + value);

  double get totalGrossProfit =>
      grossProfits.fold(0.0, (sum, value) => sum + value);

  double get totalExpenditure =>
      expenditures.fold(0.0, (sum, value) => sum + value);

  double get totalNetWorth => netWorths.fold(0.0, (sum, value) => sum + value);
}
