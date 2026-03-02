// ignore_for_file: no_leading_underscores_for_local_identifiers



extension Validations on String {
  String? validEmail() {
    if (trim().isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern.toString());
      if (!contains("@") && !regExp.hasMatch(trim())) {
        return "Invalid Email";
      }
    } else {
      return "E-mail is Required";
    }
    return null;
  }

  String? validPhoneNUmber() {
    if (trim().isNotEmpty) {
      Pattern pattern =
          r'^(?:\+?\d{1,3}[\s-]?)?(?:\(\d{1,4}\)[\s-]?)?\d{1,15}$';
      RegExp regExp = RegExp(pattern.toString());
      if (!regExp.hasMatch(trim())) {
        return "Invalid Phone Number";
      }
    } else {
      return "Phone Number is Required";
    }
    return null;
  }

  String? validPassword() {
    if (trim().isNotEmpty) {
      if (trim().length < 6) {
        return "Password is to short (minimum length is 6)";
      } else if (!RegExp(r'[A-Z]').hasMatch(trim()) ||
          !RegExp(r'[0-9]').hasMatch(trim()) ||
          !RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(trim())) {
        return 'Password must contain:\n- at least one uppercase letter\n- at least one lowercase letter\n- at least one numeric character\n- at least one special character';
      }
    } else {
      return "Password Required";
    }
    return null;
  }
}
