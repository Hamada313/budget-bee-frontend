class HValidator {
  HValidator._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email to continue";
    }

    final emailFormat =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailFormat.hasMatch(value)) {
      return "Invalid email address";
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name to continue";
    }

    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password to continue";
    }
    final passwordFormat =
        RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$");
    if (!passwordFormat.hasMatch(value)) {
      return "Password must contain at least 8 characters\n1 uppercase, 1 lowercase, 1 number and 1 special character";
    }

    return null;
  }
}
