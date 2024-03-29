enum RecipientStatus {
  pending,
  received,
  receiving,
  rejected,
  timeout,
  none,
}

extension RecipientStatusExtension on RecipientStatus {
  String get value {
    switch (this) {
      case RecipientStatus.pending:
        return 'pending';
      case RecipientStatus.received:
        return 'received';
      case RecipientStatus.receiving:
        return 'receiving';
      case RecipientStatus.rejected:
        return 'rejected';
      case RecipientStatus.timeout:
        return 'timeout';
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
      case 'receiving':
        return RecipientStatus.receiving;
      case 'rejected':
        return RecipientStatus.rejected;
      case 'timeout':
        return RecipientStatus.timeout;
      case '':
      default:
        return RecipientStatus.none;
    }
  }
}
