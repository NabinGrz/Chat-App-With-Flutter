import 'package:intl/intl.dart';

extension DateTimeToString on DateTime? {
  time() => DateFormat.jm().format(this ?? DateTime.now());
}
