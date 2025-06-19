import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/expense.dart';
import '../models/income.dart';
import 'dao/expense_dao.dart';
import 'dao/income_dao.dart';
import 'database/migration_manager.dart';

class DatabaseService {
  static Database? _database;
  static const String expenseTable = 'expenses';
  static const String incomeTable = 'incomes';
  
  final _migrationManager = DatabaseMigrationManager();
  late ExpenseDao _expenseDao;
  late IncomeDao _incomeDao;

  /// 테스트 시 사용할 데이터베이스 경로
  /// 기본값은 null이며, null일 경우 앱의 기본 문서 디렉토리에 데이터베이스를 생성합니다.
  static String? _databasePath;

  /// 테스트를 위한 데이터베이스 경로 설정
  static set databasePath(String? path) {
    _databasePath = path;
    _database = null; // 새로운 경로 설정 시 데이터베이스 인스턴스 초기화
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    _initializeDaos(_database!);
    return _database!;
  }

  void _initializeDaos(Database db) {
    _expenseDao = ExpenseDao(db);
    _incomeDao = IncomeDao(db);
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;

    final String dbPath;
    if (_databasePath != null) {
      dbPath = _databasePath!;
    } else {
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      dbPath = p.join(appDocumentsDir.path, 'moneygraph.db');
    }

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: DatabaseMigrationManager.currentVersion,
        onCreate: _migrationManager.onCreate,
        onUpgrade: _migrationManager.onUpgrade,
        onDowngrade: _migrationManager.onDowngrade,
      ),
    );
  }

  // Expense operations
  Future<void> insertExpense(Expense expense) async {
    await database;
    await _expenseDao.insert(expense);
  }

  Future<List<Expense>> getAllExpenses() async {
    await database;
    return _expenseDao.getAll();
  }

  Future<Expense?> getExpense(String id) async {
    await database;
    return _expenseDao.getById(id);
  }

  Future<void> updateExpense(Expense expense) async {
    await database;
    await _expenseDao.update(expense);
  }

  Future<void> deleteExpense(String id) async {
    await database;
    await _expenseDao.delete(id);
  }

  // Income operations
  Future<void> insertIncome(Income income) async {
    await database;
    await _incomeDao.insert(income);
  }

  Future<List<Income>> getAllIncomes() async {
    await database;
    return _incomeDao.getAll();
  }

  Future<Income?> getIncome(String id) async {
    await database;
    return _incomeDao.getById(id);
  }

  Future<void> updateIncome(Income income) async {
    await database;
    await _incomeDao.update(income);
  }

  Future<void> deleteIncome(String id) async {
    await database;
    await _incomeDao.delete(id);
  }
}
