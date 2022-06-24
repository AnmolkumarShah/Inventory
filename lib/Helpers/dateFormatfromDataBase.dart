import 'package:intl/intl.dart';

String dateFormatFromDataBase(String value) {
  return DateFormat.yMMMEd().format(DateTime.fromMillisecondsSinceEpoch(
      int.parse(value.toString().split('(')[1].toString().split('+')[0])));
}

DateTime onlyDateFromDataBase(String value) {
  return DateTime.fromMillisecondsSinceEpoch(
      int.parse(value.toString().split('(')[1].toString().split('+')[0]));
}

String dateFormat(DateTime d) {
  return DateFormat.yMMMEd().format(d);
}
