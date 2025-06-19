class Expense {
  final String id;
  final double? amount;  // null = 미확정 금액
  final DateTime transactionDate;  // 거래/결제일
  final DateTime? settlementDate;  // 실제 출금일 (null 가능)

  Expense({
    required this.id,
    this.amount,
    required this.transactionDate,
    this.settlementDate,
  });
}
