enum RecipientStatus {
  pending,
  received,
  rejected,
  none,
}

extension RecipientStatusExtension on RecipientStatus {
  String get value {
    switch (this) {
      case RecipientStatus.pending:
        return 'pending';
      case RecipientStatus.received:
        return 'received';
      case RecipientStatus.rejected:
        return 'rejected';
      case RecipientStatus.none:
      default:
        return '';
    }
  }

  static RecipientStatus fromValue(String value) {
    switch (value) {
      case 'pending':
        return RecipientStatus.pending;
      case 'received':
        return RecipientStatus.received;
      case 'rejected':
        return RecipientStatus.rejected;
      case '':
      default:
        return RecipientStatus.none;
    }
  }
}
