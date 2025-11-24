class Validation {
  Validation._();

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email address';
    }

    if (!email.contains('@')) {
      return 'Invalid email';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    const specialChars = '!#%&()*+,-./<=>?@_';

    if (password == null || password.isEmpty) {
      return 'Password can not be empty';
    }

    if (password.length < 8) {
      return 'Password should be at least 8 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password should contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password should contain at least one digit';
    }

    if (!password.contains(RegExp('[$specialChars]'))) {
      return 'Password should contain at least one of \'$specialChars\'';
    }

    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Can not be empty';
    }

    return null;
  }
}