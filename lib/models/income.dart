class Income {
  final String id;
  final double? amount;  // null = 미확정 금액
  final DateTime timestamp;  // 날짜명 변경
  final String? memo;

  Income({
    required this.id,
    this.amount,
    required this.timestamp,  // 파라미터명 변경
    this.memo,
  });
}