import 'package:intl/intl.dart';

extension DateTimeExtenstion on DateTime {
  String displayDateString({bool? includeTime}) {
    return DateFormat('E MMM d, ' 'yyyy').format(this);
  }

  String displayChartDateString() {
    // Jun 6, Jun 7
    return DateFormat('MMM d').format(this);
  }

  String returnMonth() {
    // Jun 6, Jun 7
    return DateFormat('MMM').format(this);
  }

  String toOnlyDate() {
    return toString().split(" ")[0];
  }
}
