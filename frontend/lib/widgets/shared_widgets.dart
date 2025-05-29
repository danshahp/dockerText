import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTable extends StatelessWidget {
  //  headers
  final List<CustomTableRow> children;
  const CustomTable({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [...children],
    );
  }
}

class CustomTableRow extends TableRow {
  final bool isHeader;
  final Color? headerColor;
  final Decoration? decorationAll;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets cellPadding;
  final List<TableCell> cells;
  CustomTableRow({
    super.key,
    required this.cells,
    this.headerColor,
    this.cellPadding = const EdgeInsets.all(8.0),
    this.decorationAll,
    this.leading,
    this.trailing,
    this.isHeader = false,
  }) : super(
         children: [
           if (leading != null)
             TableCell(child: Padding(padding: cellPadding, child: leading)),
           ...cells.map(
             (cell) => TableCell(
               verticalAlignment: cell.verticalAlignment,
               child: Padding(padding: cellPadding, child: cell.child),
             ),
           ),
           if (trailing != null)
             TableCell(child: Padding(padding: cellPadding, child: trailing)),
         ],
       );

  @override
  Decoration? get decoration =>
      isHeader
          ? BoxDecoration(
            color: headerColor ?? Colors.greenAccent.withOpacity(0.1),
          )
          : decorationAll ?? BoxDecoration();
}

class MoneyText extends Text {
  MoneyText(
    dynamic amount, {
    Key? key,
    String? currency,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) : super(
         _formatAmount(amount, currency),
         key: key,
         style: style,
         strutStyle: strutStyle,
         textAlign: textAlign,
         locale: locale,
         softWrap: softWrap,
         overflow: overflow,
         maxLines: maxLines,
         semanticsLabel: semanticsLabel,
         textWidthBasis: textWidthBasis,
         textHeightBehavior: textHeightBehavior,
       );

  static String _formatAmount(dynamic amount, String? currency) {
    double value;

    if (amount is String) {
      value = double.tryParse(amount.replaceAll(",", "")) ?? 0.0;
    } else if (amount is double || amount is int) {
      value = amount.toDouble();
    } else {
      value = 0.0;
    }

    final formatter = NumberFormat("#,##0", "en_US");
    final formatted = formatter.format(value);
    final prefix = currency ?? "TSH";

    return "$prefix $formatted";
  }
}
