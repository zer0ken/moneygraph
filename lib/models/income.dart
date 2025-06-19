class Income {
  final String id;
  final double? amount;  // null = 미확정 금액
  final DateTime date;

  Income({
    required this.id,
    this.amount,
    required this.date,
  });
}