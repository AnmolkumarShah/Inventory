String formateDate(DateTime date) {
  final List<String> list = date.toIso8601String().split('T');
  return list[0];
}
