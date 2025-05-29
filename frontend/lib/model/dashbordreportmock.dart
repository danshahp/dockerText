import 'dart:math';

import 'package:tanzanian_bms/model/dashboardreport.dart';

final weeklySales = WeeklySales(
  days: [
    DailySales(weekday: 'Monday', cashSales: 305000, creditSales: 23000),
    DailySales(weekday: 'Tuesday', cashSales: 900000, creditSales: 100000),
    DailySales(weekday: 'Wednesday', cashSales: 2300000, creditSales: 800000),
    DailySales(weekday: 'Thursday', cashSales: 4310000, creditSales: 20000),
    DailySales(weekday: 'Friday', cashSales: 500000, creditSales: 480000),
    DailySales(weekday: 'Saturday', cashSales: 1290000, creditSales: 7830000),
    DailySales(weekday: 'Sunday', cashSales: 1000000, creditSales: 2000000),
  ],
);

final dailyBusinessSummary = DailyBusinessSummary(
  todaysCashSales: 125000,
  todaysCashProfit: 37000,
  todaysExpenditure: 22000,
  todaysCreditSales: 88000,
  todaysCreditExpectedProfit: 19000,
  itemsOutOfStock: 243,
  itemsExpiredOrAboutToExpire: 1665,
  overdueInvoices: 149,
  todaysAdvancePayments: 15000,
  todaysInvoicePayments: 46000,
  todaysSupplierBillPayments: 38000,
  totalCashInHand: 122000,
);

final monthlyFinemceSummary = MonthlyFinancialSummary(
  cashSales: generateRandomList(200000, 700000),
  creditSales: generateRandomList(100000, 500000),
  costOfGoodsSold: generateRandomList(300000, 800000),
  expenditures: generateRandomList(50000, 200000),
);

List<double> generateRandomList(double min, double max) {
  return List.generate(
    12,
    (_) => (min + Random().nextDouble() * (max - min)).roundToDouble(),
  );
}
