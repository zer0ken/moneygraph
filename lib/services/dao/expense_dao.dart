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
        'transaction_date': expense.transactionDate.millisecondsSinceEpoch,
        'settlement_date': expense.settlementDate?.millisecondsSinceEpoch,
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
        'transaction_date': expense.transactionDate.millisecondsSinceEpoch,
        'settlement_date': expense.settlementDate?.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Expense _mapToExpense(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      transactionDate: DateTime.fromMillisecondsSinceEpoch(
        map['transaction_date'],
      ),
      settlementDate: map['settlement_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['settlement_date'])
          : null,
    );
  }
}
