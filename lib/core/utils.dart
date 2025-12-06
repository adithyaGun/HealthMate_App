import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final f = DateFormat('yyyy-MM-dd');
  return f.format(date);
}


