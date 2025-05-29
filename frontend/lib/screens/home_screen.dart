import 'package:flutter/material.dart';
import 'package:tanzanian_bms/model/dashboardreport.dart';
import 'package:tanzanian_bms/model/dashbordreportmock.dart';
import 'package:tanzanian_bms/widgets/chartbuilder.dart';
import 'package:tanzanian_bms/widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),

      children: [
        const SizedBox(height: 20),
        businessSummaryTable(),
        const SizedBox(height: 20),
        weeklySalesTable(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ChartBuilder(
                type: ChartType.bar,
                data: [
                  ...weeklySales.days.map(
                    (day) => ChartData(
                      label: day.weekday,
                      value: day.cashSales,
                      seriesName: 'Cash Sales',
                      color: colors[0],
                    ),
                  ),
                  ...weeklySales.days.map(
                    (day) => ChartData(
                      label: day.weekday,
                      value: day.creditSales,
                      seriesName: 'Credit Sales',
                      color: colors[1],
                    ),
                  ),
                ],

                title: 'Sales In Each Day Of This Week',
              ),
            ),
            Expanded(
              child: ChartBuilder(
                type: ChartType.bar,
                data:
                    weeklySales.days
                        .map(
                          (day) => ChartData(
                            label: day.weekday,
                            value: day.cashSales,
                            seriesName: 'Cash Sales',
                            color: colors[0],
                          ),
                        )
                        .toList(),
                title: 'Cash sales',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        monthlyCashCreditSalesTable(),
        const SizedBox(height: 20),
        ChartBuilder(
          type: ChartType.barLinechart,
          data:
              monthlyFinemceSummary.cashPlusCredit
                  .map(
                    (value) => ChartData(
                      label:
                          MonthlyFinancialSummary.months[monthlyFinemceSummary
                              .cashPlusCredit
                              .indexOf(value)],
                      value: value,
                      seriesName: 'Total Sales',
                      color: colors[0],
                    ),
                  )
                  .toList(),
          title: 'Monthly Cash + Credit Sales',
        ),
        const SizedBox(height: 20),
        monthlyFinanceTable(),
        const SizedBox(height: 20),
        ChartBuilder(
          type: ChartType.bar,
          data: [
            ...monthlyFinemceSummary.grossProfits.map(
              (value) => ChartData(
                label:
                    MonthlyFinancialSummary.months[monthlyFinemceSummary
                        .grossProfits
                        .indexOf(value)],
                value: value,
                seriesName: 'Gross profit',
                color: colors[0],
              ),
            ),
            ...monthlyFinemceSummary.expenditures.map(
              (value) => ChartData(
                label:
                    MonthlyFinancialSummary.months[monthlyFinemceSummary
                        .expenditures
                        .indexOf(value)],
                value: value,
                seriesName: 'Expenditures',
                color: colors[1],
              ),
            ),
            ...monthlyFinemceSummary.netWorths.map(
              (value) => ChartData(
                label:
                    MonthlyFinancialSummary.months[monthlyFinemceSummary
                        .netWorths
                        .indexOf(value)],
                value: value,
                seriesName: 'Net worth',
                color: colors[2],
              ),
            ),
          ],

          title: 'Monthly Credit Sales',
        ),
      ],
    );
  }

  Widget weeklySalesTable() {
    return CustomTable(
      children: [
        CustomTableRow(
          isHeader: true,
          leading: Text('WeekDays'),
          cells:
              weeklySales.days.map((day) {
                return TableCell(child: Text(day.weekday));
              }).toList(),
        ),
        CustomTableRow(
          leading: Text('Cash Sales'),
          cells:
              weeklySales.days.map((day) {
                return TableCell(child: MoneyText(day.cashSales.toString()));
              }).toList(),
        ),
        CustomTableRow(
          leading: Text('Credit Sales'),
          cells:
              weeklySales.days.map((day) {
                return TableCell(child: MoneyText(day.creditSales.toString()));
              }).toList(),
        ),
        CustomTableRow(
          leading: Text('Total Sales (Cash+Credit) Per Day'),
          cells:
              weeklySales.days.map((day) {
                return TableCell(child: MoneyText(day.totalSales.toString()));
              }).toList(),
        ),
      ],
    );
  }

  Widget businessSummaryTable() {
    return CustomTable(
      children: [
        CustomTableRow(
          isHeader: true,
          cells:
              DailyBusinessSummary.titles
                  .map((title) => TableCell(child: Text(title)))
                  .toList(),
        ),
        CustomTableRow(
          cells:
              dailyBusinessSummary
                  .toMap()
                  .values
                  .map(
                    (value) => TableCell(
                      child: Container(
                        // width: 70,
                        // height: 70,
                        // padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(100),
                        ),

                        child: Center(child: MoneyText(value.toString())),
                      ),
                    ),
                  ) //Text(value.toString()
                  .toList(),
        ),
      ],
    );
  }

  Widget monthlyCashCreditSalesTable() {
    return CustomTable(
      children: [
        CustomTableRow(
          isHeader: true,
          leading: Text('Months'),
          cells:
              MonthlyFinancialSummary.months
                  .map((title) => TableCell(child: Text(title)))
                  .toList(),
        ),

        CustomTableRow(
          leading: Text('Total Sales'),
          cells:
              monthlyFinemceSummary.cashPlusCredit
                  .map((value) => TableCell(child: MoneyText(value.toString())))
                  .toList(),
        ),
      ],
    );
  }

  Widget monthlyFinanceTable() {
    return CustomTable(
      children: [
        CustomTableRow(
          leading: Text('Months'),
          trailing: Text('Total'),
          isHeader: true,
          cells:
              MonthlyFinancialSummary.months
                  .map((title) => TableCell(child: Text(title)))
                  .toList(),
        ),
        CustomTableRow(
          leading: Text('Gross Profits'),
          trailing: MoneyText(
            monthlyFinemceSummary.totalGrossProfit.toString(),
          ),
          cells:
              monthlyFinemceSummary.grossProfits
                  .map((value) => TableCell(child: MoneyText(value.toString())))
                  .toList(),
        ),
        CustomTableRow(
          leading: Text('Expenditures'),
          trailing: MoneyText(
            monthlyFinemceSummary.totalExpenditure.toString(),
          ),
          cells:
              monthlyFinemceSummary.expenditures
                  .map((value) => TableCell(child: MoneyText(value.toString())))
                  .toList(),
        ),
        CustomTableRow(
          leading: Text('Net Worth'),
          trailing: MoneyText(monthlyFinemceSummary.totalNetWorth.toString()),
          cells:
              monthlyFinemceSummary.netWorths
                  .map((value) => TableCell(child: MoneyText(value.toString())))
                  .toList(),
        ),
      ],
    );
  }
}

final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
