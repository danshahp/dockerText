import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartType { bar, line, piechart, barLinechart }

class ChartBuilder extends StatelessWidget {
  final ChartType type;
  final List<ChartData> data;
  final String title;
  final bool isHorizontal;
  const ChartBuilder({
    super.key,
    required this.type,
    required this.data,
    required this.title,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ChartType.piechart) {
      return SfCircularChart(
        title: ChartTitle(text: title),
        legend: Legend(isVisible: true),
        series: <PieSeries<ChartData, String>>[
          PieSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            dataLabelMapper: (d, _) => d.seriesName,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            name: 'Pie',
          ),
        ],
      );
    }

    return SfCartesianChart(
      title: ChartTitle(text: title),
      primaryXAxis: CategoryAxis(),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _buildCartesianSeries(),
    );
  }

  List<CartesianSeries<ChartData, String>> _buildCartesianSeries() {
    final Map<String, List<ChartData>> grouped = {};
    for (final d in data) {
      grouped.putIfAbsent(d.seriesName, () => []).add(d);
    }

    switch (type) {
      case ChartType.bar:
        return grouped.entries.map((entry) {
          return ColumnSeries<ChartData, String>(
            name: entry.key,
            dataSource: entry.value,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          );
        }).toList();

      case ChartType.line:
        return grouped.entries.map((entry) {
          return LineSeries<ChartData, String>(
            name: entry.key,
            dataSource: entry.value,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          );
        }).toList();

      case ChartType.barLinechart:
        if (grouped.length == 1) {
          // Only one series: overlay both line and bar
          final singleSeries = grouped.entries.first.value;

          return [
            ColumnSeries<ChartData, String>(
              name: singleSeries.first.seriesName,
              dataSource: singleSeries,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, _) => d.color,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            LineSeries<ChartData, String>(
              name: singleSeries.first.seriesName,
              dataSource: singleSeries,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, _) => d.color,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ];
        } else {
          // Multiple series: respect the `chartType` of each entry
          final List<CartesianSeries<ChartData, String>> result = [];

          for (var entry in grouped.entries) {
            final dataList = entry.value;

            final SingleChartType type =
                dataList.first.chartType ??
                SingleChartType.bar; // default if not specified

            if (type == SingleChartType.bar) {
              result.add(
                ColumnSeries<ChartData, String>(
                  name: entry.key,
                  dataSource: dataList,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) => d.color,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              );
            } else if (type == SingleChartType.line) {
              result.add(
                LineSeries<ChartData, String>(
                  name: entry.key,
                  dataSource: dataList,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) => d.color,
                  markerSettings: const MarkerSettings(isVisible: true),
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              );
            }
          }

          return result;
        }

      default:
        return [];
    }
  }
}

enum SingleChartType { bar, line }

class ChartData {
  final String label;
  final double value;
  final String seriesName;
  final Color color;
  final SingleChartType?
  chartType; // Optional: only required if multiple seriesNames exist

  ChartData({
    required this.label,
    required this.value,
    required this.seriesName,
    required this.color,
    this.chartType,
  });
}
