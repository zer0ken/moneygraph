import 'package:sqflite_common/sqlite_api.dart';
import '../../models/expense.dart';
import 'base_dao.dart';

class ExpenseDao implements BaseDao<Expense> {
  final Database _database;
  
  @override
  String get tableName => 'expenses';
  
  @override
  Database get database => _database;

  ExpenseDao(this._database);

  @override
  Future<void> insert(Expense expense) async {
    await database.insert(
      tableName,
      {
        'id': expense.id,
        'amount': expense.amount,
        'timestamp': expense.timestamp.millisecondsSinceEpoch,
        'settlement_date': expense.settlementDate?.millisecondsSinceEpoch,
        'memo': expense.memo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Expense>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query(tableName);
    return maps.map(_mapToExpense).toList();
  }

  @override
  Future<Expense?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _mapToExpense(maps.first);
  }

  @override
  Future<void> update(Expense expense) async {
    await database.update(
      tableName,
      {
        'amount': expense.amount,
        'timestamp': expense.timestamp.millisecondsSinceEpoch,
        'settlement_date': expense.settlementDate?.millisecondsSinceEpoch,
        'memo': expense.memo,
      },
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// 특정 날짜의 지출 내역 조회
  Future<List<Expense>> getByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await database.query(
      tableName,
      where: 'timestamp >= ? AND timestamp < ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
    );

    return maps.map(_mapToExpense).toList();
  }

  Expense _mapToExpense(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      amount: map['amount'] as double?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      settlementDate: map['settlement_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['settlement_date'] as int)
          : null,
      memo: map['memo'] as String?,
    );
  }
}
