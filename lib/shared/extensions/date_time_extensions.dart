import 'package:intl/intl.dart';

extension DateTimeToString on DateTime? {
  time() => DateFormat.jm().format(this ?? DateTime.now());
  get onlyDate => DateFormat.yMd().format(this ?? DateTime.now());
  String format(String type) => DateFormat(type).format(this ?? DateTime.now());
}
