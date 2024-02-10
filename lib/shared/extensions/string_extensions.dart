extension StringExtensions on String {
  String get capitialize =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  DateTime get toDate => DateTime.parse(this);
}
