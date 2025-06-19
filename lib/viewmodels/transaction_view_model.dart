import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/income.dart';
import '../models/expense.dart';
import '../services/database_service.dart';

class TransactionViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionViewModel(this._databaseService) {
    loadTransactions();
  }

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTransactions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 수입과 지출 데이터를 동시에 가져옵니다
      final expenses = await _databaseService.getAllExpenses();
      final incomes = await _databaseService.getAllIncomes();

      // 수입과 지출을 Transaction 객체로 변환하고 하나의 리스트로 결합합니다
      _transactions = [
        ...expenses.map(
          (e) => Transaction(
            timestamp: e.timestamp,
            amount: -(e.amount ?? 0), // 지출은 음수로 표시, null일 경우 0으로 처리
            memo: e.memo ?? '지출',
          ),
        ),
        ...incomes.map(
          (i) => Transaction(
            timestamp: i.timestamp,
            amount: i.amount ?? 0, // null일 경우 0으로 처리
            memo: i.memo ?? '수입',
          ),
        ),
      ];

      // 날짜순으로 정렬 (최신순)
      _transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 특정 기간의 트랜잭션만 필터링
  List<Transaction> getTransactionsForPeriod(DateTime start, DateTime end) {
    return _transactions.where((transaction) {
      return transaction.timestamp.isAfter(
            start.subtract(const Duration(days: 1)),
          ) &&
          transaction.timestamp.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // 특정 기간의 총 수입
  double getTotalIncomeForPeriod(DateTime start, DateTime end) {
    return getTransactionsForPeriod(
      start,
      end,
    ).where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
  }

  // 특정 기간의 총 지출
  double getTotalExpenseForPeriod(DateTime start, DateTime end) {
    return getTransactionsForPeriod(
      start,
      end,
    ).where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  // 새로운 거래가 추가되거나 수정될 때 호출
  Future<void> refreshTransactions() async {
    await loadTransactions();
  }

  // 거래 추가
  Future<void> addTransaction({
    required DateTime timestamp,
    required double amount,
    required String memo,
    required bool isIncome,
  }) async {
    try {
      final id = const Uuid().v4();
      if (isIncome) {
        await _databaseService.insertIncome(
          Income(
            id: id,
            timestamp: timestamp,
            amount: amount,
            memo: memo,
          ),
        );
      } else {
        await _databaseService.insertExpense(
          Expense(
            id: id,
            timestamp: timestamp,
            amount: amount,
            memo: memo,
          ),
        );
      }
      await refreshTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
