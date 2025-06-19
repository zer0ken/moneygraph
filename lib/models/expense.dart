class Expense {
  final String id;
  final double? amount;  // null = 미확정 금액
  final DateTime timestamp;  // 거래/결제일
  final DateTime? settlementDate;  // 실제 출금일 (null 가능)
  final String? memo;  // 메모 추가

  Expense({
    required this.id,
    this.amount,
    required this.timestamp,  // 파라미터명 변경
    this.settlementDate,
    this.memo,  // 메모 파라미터 추가
  });
}
