class Validators {
  String? validateMobile(String? value) {
    if (value!.isEmpty) {
      return 'Mobile field cannot be empty';
    }
    if (value.length < 11) {
      return 'Please enter 11 digits';
    }
    // Regex for email validation
    String p = r'(^(?:[+0][1-9])?[0-9]{8,13}$)';
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Mobile provided isn\'t valid.Try another mobile No.';
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email field cannot be empty';
    }
    // Regex for email validation
    String p = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email provided isn\'t valid.Try another email address';
  }

  String? validateCNIC(String? value) {
    if (value!.isEmpty) {
      return 'CNIC field cannot be empty';
    } else {
      if (value.length < 13) {
        return 'CNIC length must be 13 digits';
      }

      return null;
    }
  }

  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Username field cannot be empty';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password field cannot be empty';
    }
    // Use any password length of your choice here
    if (value.length < 6) {
      return 'Password length must be 6 digit';
    }
    return null;
  }

  String? validateVerificationCode(String? value) {
    if (value!.isEmpty) {
      return 'Password field cannot be empty';
    }
    // Use any password length of your choice here
    if (value.length < 8) {
      return 'Password length must be 8 digits';
    }
    return null;
  }

  String? validateField(String? value) {
    if (value!.isEmpty) {
      return 'Field can not be empty';
    }
    if (value.length < 3) {
      return 'Field length must be 3 digits';
    }
    return null;
  }

  String? validatePin(String? value) {
    if (value!.isEmpty) {
      return 'PIN field cannot be empty';
    }
    if (value.length < 4) {
      return 'PIN length must be 4 digits';
    }
    // String p = r'(^(?:[+0][1-9])?[0-9]{8,13}$)';
    // RegExp regExp = RegExp(p);
    // if (regExp.hasMatch(value)) {
    //   return 'Pin provided isn\'t valid.Try another pin';
    // }
    return null;
  }

  String? validateName(String? value) {
    var emptyNameError = 'Name field cannot be empty';
    var shortNameError = 'Name is too short';
    var invalidNameError = 'Name is not appropriate';

    print(value.toString());

    if (value!.isEmpty) {
      return emptyNameError;
    } else if (value.length < 3) {
      return shortNameError;
    } else {
      final nameValidate = RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$").hasMatch(value);
      if (!nameValidate) {
        return invalidNameError;
      } else {
        return null;
      }
    }
  }

  // String? validateMobile(String? value) {
  //   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  //   RegExp regExp = new RegExp(pattern);
  //   if (value!.isEmpty) {
  //     return 'Please enter mobile number';
  //   }
  //   // else if (!regExp.hasMatch(value)) {
  //   //   return 'Please enter valid mobile number';
  //   // }
  //   return null;
  // }
}
