import 'package:flutter_test/flutter_test.dart';
import 'package:moneygraph/models/expense.dart';
import 'package:moneygraph/models/income.dart';
import 'package:moneygraph/models/transaction.dart';
import 'package:moneygraph/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

void main() {
  late DatabaseService databaseService;
  const uuid = Uuid();

  setUpAll(() {
    // SQLite 초기화
    sqfliteFfiInit();
  });

  setUp(() async {
    // 각 테스트마다 새로운 인메모리 데이터베이스 사용
    databaseService = DatabaseService();
    // 테스트용 인메모리 데이터베이스 경로 설정을 위한 오버라이드
    DatabaseService.databasePath = inMemoryDatabasePath;
    // 데이터베이스 초기화 (데이터베이스가 처음 생성될 때 자동으로 onCreate가 호출됨)
  });

  tearDown(() async {
    // 테스트 완료 후 데이터베이스 연결 종료
    final db = await databaseService.database;
    await db.close();
    DatabaseService.databasePath = null;
  });

  group('Expense / ', () {
    test('새로운 지출을 데이터베이스에 추가할 수 있어야 한다', () async {
      final expense = Expense(
        id: uuid.v4(),
        amount: 10000,
        timestamp: DateTime(2025, 6, 19),
        settlementDate: DateTime(2025, 6, 20),
      );

      await databaseService.insertExpense(expense);
      final result = await databaseService.getExpense(expense.id);

      expect(result, isNotNull);
      expect(result!.id, equals(expense.id));
      expect(result.amount, equals(expense.amount));
      expect(result.timestamp.day, equals(expense.timestamp.day));
      expect(result.settlementDate?.day, equals(expense.settlementDate?.day));
    });

    test('저장된 모든 지출 내역을 조회할 수 있어야 한다', () async {
      final expense1 = Expense(
        id: uuid.v4(),
        amount: 10000,
        timestamp: DateTime(2025, 6, 19),
      );
      final expense2 = Expense(
        id: uuid.v4(),
        amount: 20000,
        timestamp: DateTime(2025, 6, 20),
      );

      await databaseService.insertExpense(expense1);
      await databaseService.insertExpense(expense2);

      final expenses = await databaseService.getAllExpenses();

      expect(expenses.length, equals(2));
      expect(expenses.map((e) => e.id), contains(expense1.id));
      expect(expenses.map((e) => e.id), contains(expense2.id));
    });

    test('기존 지출 내역의 정보를 수정할 수 있어야 한다', () async {
      final expense = Expense(
        id: uuid.v4(),
        amount: 10000,
        timestamp: DateTime(2025, 6, 19),
      );

      await databaseService.insertExpense(expense);

      final updatedExpense = Expense(
        id: expense.id,
        amount: 15000,
        timestamp: DateTime(2025, 6, 20),
        settlementDate: DateTime(2025, 6, 21),
      );

      await databaseService.updateExpense(updatedExpense);
      final result = await databaseService.getExpense(expense.id);

      expect(result, isNotNull);
      expect(result!.amount, equals(updatedExpense.amount));
      expect(result.timestamp.day, equals(updatedExpense.timestamp.day));
      expect(
        result.settlementDate?.day,
        equals(updatedExpense.settlementDate?.day),
      );
    });

    test('지출 내역을 삭제할 수 있어야 한다', () async {
      final expense = Expense(
        id: uuid.v4(),
        amount: 10000,
        timestamp: DateTime(2025, 6, 19),
      );

      await databaseService.insertExpense(expense);
      await databaseService.deleteExpense(expense.id);

      final result = await databaseService.getExpense(expense.id);
      expect(result, isNull);
    });
  });
  group('Income / ', () {
    test('새로운 수입을 데이터베이스에 추가할 수 있어야 한다', () async {
      final income = Income(
        id: uuid.v4(),
        amount: 3000000,
        timestamp: DateTime(2025, 6, 19),
      );

      await databaseService.insertIncome(income);
      final result = await databaseService.getIncome(income.id);

      expect(result, isNotNull);
      expect(result!.id, equals(income.id));
      expect(result.amount, equals(income.amount));
      expect(result.timestamp.day, equals(income.timestamp.day));
    });

    test('저장된 모든 수입 내역을 조회할 수 있어야 한다', () async {
      final income1 = Income(
        id: uuid.v4(),
        amount: 3000000,
        timestamp: DateTime(2025, 6, 19),
      );
      final income2 = Income(
        id: uuid.v4(),
        amount: 500000,
        timestamp: DateTime(2025, 6, 20),
      );

      await databaseService.insertIncome(income1);
      await databaseService.insertIncome(income2);

      final incomes = await databaseService.getAllIncomes();

      expect(incomes.length, equals(2));
      expect(incomes.map((e) => e.id), contains(income1.id));
      expect(incomes.map((e) => e.id), contains(income2.id));
    });

    test('기존 수입 내역의 정보를 수정할 수 있어야 한다', () async {
      final income = Income(
        id: uuid.v4(),
        amount: 3000000,
        timestamp: DateTime(2025, 6, 19),
      );

      await databaseService.insertIncome(income);

      final updatedIncome = Income(
        id: income.id,
        amount: 3500000,
        timestamp: DateTime(2025, 6, 20),
      );

      await databaseService.updateIncome(updatedIncome);
      final result = await databaseService.getIncome(income.id);

      expect(result, isNotNull);
      expect(result!.amount, equals(updatedIncome.amount));
      expect(result.timestamp.day, equals(updatedIncome.timestamp.day));
    });

    test('수입 내역을 삭제할 수 있어야 한다', () async {
      final income = Income(
        id: uuid.v4(),
        amount: 3000000,
        timestamp: DateTime(2025, 6, 19),
      );

      await databaseService.insertIncome(income);
      await databaseService.deleteIncome(income.id);

      final result = await databaseService.getIncome(income.id);
      expect(result, isNull);
    });
  });
  group('Transaction / ', () {
    test('특정 날짜의 모든 거래 내역을 시간순으로 조회할 수 있어야 한다', () async {
      final DateTime testDate = DateTime(2025, 6, 19);
      
      // 테스트 데이터 생성
      final expense1 = Expense(
        id: uuid.v4(),
        amount: 10000,
        timestamp: DateTime(2025, 6, 19, 10, 30), // 10:30
        memo: '아침 식사',
      );
      
      final expense2 = Expense(
        id: uuid.v4(),
        amount: 20000,
        timestamp: DateTime(2025, 6, 19, 14, 0), // 14:00
        memo: '점심 식사',
      );
      
      final income1 = Income(
        id: uuid.v4(),
        amount: 50000,
        timestamp: DateTime(2025, 6, 19, 12, 0), // 12:00
        memo: '용돈',
      );

      // 데이터베이스에 테스트 데이터 저장
      await databaseService.insertExpense(expense1);
      await databaseService.insertExpense(expense2);
      await databaseService.insertIncome(income1);

      // 다른 날짜의 거래도 추가 (이 거래는 결과에 포함되면 안 됨)
      await databaseService.insertExpense(
        Expense(
          id: uuid.v4(),
          amount: 5000,
          timestamp: DateTime(2025, 6, 20), // 다른 날짜
        ),
      );

      final transactions = await databaseService.getTransactionsByDate(testDate);

      // 검증
      expect(transactions.length, equals(3)); // 해당 날짜의 거래만 포함되어야 함
      
      // 시간순 정렬 검증
      expect(transactions[0].timestamp, equals(expense1.timestamp));
      expect(transactions[1].timestamp, equals(income1.timestamp));
      expect(transactions[2].timestamp, equals(expense2.timestamp));
        // 금액의 부호로 거래 타입 검증
      expect(transactions[0].amount, lessThan(0)); // 지출은 음수
      expect(transactions[1].amount, greaterThan(0)); // 수입은 양수
      expect(transactions[2].amount, lessThan(0)); // 지출은 음수

      // 실제 금액 검증
      expect(transactions[0].amount, equals(-10000));
      expect(transactions[1].amount, equals(50000));
      expect(transactions[2].amount, equals(-20000));
    });
  });
}
