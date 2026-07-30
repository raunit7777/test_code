extension StringExtension on String {

  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeFirstOfEach() {
    return split(" ").map((str) => str.capitalize()).join(" ");
  }

  bool get isValidEmail {

    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r"^[0-9]{10}$").hasMatch(this);
  }
}