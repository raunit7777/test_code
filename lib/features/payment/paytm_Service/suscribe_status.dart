/// Explicit payment states according to mobile security and payment state machine standards
enum PaymentState {
  initial,
  initiated,
  verifying,
  paid,
  pending,
  failed,
  expired;

  bool get isBusy => this == PaymentState.initiated || this == PaymentState.verifying;
  bool get isPaid => this == PaymentState.paid;
  bool get isPending => this == PaymentState.pending;
  bool get isFailed => this == PaymentState.failed;
  bool get isExpired => this == PaymentState.expired;
}

/// Backwards-compatible SubscribeStatus
enum SubscribeStatus {
  initial,
  idle,
  loading,
  initiating,
  launchingPaytm,
  verifying,
  success,
  paid,
  pending,
  failed,
  failure,
  expired,
}
