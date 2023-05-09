enum Role {
  donor,
  recipient,
  none,
}

extension RoleExtension on Role {
  String get value {
    switch (this) {
      case Role.donor:
        return 'donor';
      case Role.recipient:
        return 'recipient';
      case Role.none:
      default:
        return '';
    }
  }

  static Role fromValue(String value) {
    switch (value) {
      case 'donor':
        return Role.donor;
      case 'recipient':
        return Role.recipient;
      case '':
      default:
        return Role.none;
    }
  }
}
