import 'income.dart';
import 'expense.dart';

class Transaction {
  
  final DateTime timestamp;
  final double amount;
  final String memo;

  Transaction({
    required this.timestamp,
    required this.amount,
    required this.memo,
  });

  /// Income을 Transaction으로 변환
  factory Transaction.fromIncome(Income income) {
    return Transaction(
      timestamp: income.timestamp,
      amount: income.amount ?? 0,
      memo: income.memo ?? '수입입니다.',
    );
  }

  /// Expense를 Transaction으로 변환
  factory Transaction.fromExpense(Expense expense) {
    return Transaction(
      timestamp: expense.timestamp,
      amount: -(expense.amount ?? 0),  // 지출은 음수로 표시
      memo: expense.memo ?? '지출입니다.',
    );
  }
}
