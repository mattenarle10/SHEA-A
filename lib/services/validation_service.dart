class ValidationService {
  // Validate first name
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  // Validate last name
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  // Validate address
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  // Validate contact number (Philippine format: 09XXXXXXXXX or 639XXXXXXXXX)
  static String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact number';
    }
    if (!RegExp(r'^(09\d{9}|639\d{9})$').hasMatch(value)) {
      return 'Please enter a valid Philippine contact number';
    }
    return null;
  }

  // Validate emergency contact number (Philippine format: 09XXXXXXXXX or 639XXXXXXXXX)
  static String? validateEmergencyContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your emergency contact number';
    }
    if (!RegExp(r'^(09\d{9}|639\d{9})$').hasMatch(value)) {
      return 'Please enter a valid Philippine contact number';
    }
    return null;
  }

  // Validate building number
  static String? validateBuilding(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the building name';
    }
    return null;
  }

  // Validate floor number
  static String? validateFloor(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the floor number';
    }
    return null;
  }

  // Validate room number
  static String? validateRoom(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the room number';
    }
    return null;
  }
}
