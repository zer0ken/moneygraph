import 'package:flutter_test/flutter_test.dart';
import 'package:moneygraph/models/expense.dart';
import 'package:moneygraph/models/income.dart';
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
    // 테이블 초기화
    final db = await databaseService.database;
    await db.delete(DatabaseService.expenseTable);
    await db.delete(DatabaseService.incomeTable);
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
        transactionDate: DateTime(2025, 6, 19),
        settlementDate: DateTime(2025, 6, 20),
      );

      await databaseService.insertExpense(expense);
      final result = await databaseService.getExpense(expense.id);

      expect(result, isNotNull);
      expect(result!.id, equals(expense.id));
      expect(result.amount, equals(expense.amount));
      expect(result.transactionDate.day, equals(expense.transactionDate.day));
      expect(result.settlementDate?.day, equals(expense.settlementDate?.day));
    });

    test('저장된 모든 지출 내역을 조회할 수 있어야 한다', () async {
      final expense1 = Expense(
        id: uuid.v4(),
        amount: 10000,
        transactionDate: DateTime(2025, 6, 19),
      );
      final expense2 = Expense(
        id: uuid.v4(),
        amount: 20000,
        transactionDate: DateTime(2025, 6, 20),
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
        transactionDate: DateTime(2025, 6, 19),
      );

      await databaseService.insertExpense(expense);

      final updatedExpense = Expense(
        id: expense.id,
        amount: 15000,
        transactionDate: DateTime(2025, 6, 20),
        settlementDate: DateTime(2025, 6, 21),
      );

      await databaseService.updateExpense(updatedExpense);
      final result = await databaseService.getExpense(expense.id);

      expect(result, isNotNull);
      expect(result!.amount, equals(updatedExpense.amount));
      expect(
        result.transactionDate.day,
        equals(updatedExpense.transactionDate.day),
      );
      expect(
        result.settlementDate?.day,
        equals(updatedExpense.settlementDate?.day),
      );
    });

    test('지출 내역을 삭제할 수 있어야 한다', () async {
      final expense = Expense(
        id: uuid.v4(),
        amount: 10000,
        transactionDate: DateTime(2025, 6, 19),
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
        date: DateTime(2025, 6, 19),
      );

      await databaseService.insertIncome(income);
      final result = await databaseService.getIncome(income.id);

      expect(result, isNotNull);
      expect(result!.id, equals(income.id));
      expect(result.amount, equals(income.amount));
      expect(result.date.day, equals(income.date.day));
    });

    test('저장된 모든 수입 내역을 조회할 수 있어야 한다', () async {
      final income1 = Income(
        id: uuid.v4(),
        amount: 3000000,
        date: DateTime(2025, 6, 19),
      );
      final income2 = Income(
        id: uuid.v4(),
        amount: 500000,
        date: DateTime(2025, 6, 20),
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
        date: DateTime(2025, 6, 19),
      );

      await databaseService.insertIncome(income);

      final updatedIncome = Income(
        id: income.id,
        amount: 3500000,
        date: DateTime(2025, 6, 20),
      );

      await databaseService.updateIncome(updatedIncome);
      final result = await databaseService.getIncome(income.id);

      expect(result, isNotNull);
      expect(result!.amount, equals(updatedIncome.amount));
      expect(result.date.day, equals(updatedIncome.date.day));
    });

    test('수입 내역을 삭제할 수 있어야 한다', () async {
      final income = Income(
        id: uuid.v4(),
        amount: 3000000,
        date: DateTime(2025, 6, 19),
      );

      await databaseService.insertIncome(income);
      await databaseService.deleteIncome(income.id);

      final result = await databaseService.getIncome(income.id);
      expect(result, isNull);
    });
  });
}
