import 'package:sqflite_common/sqlite_api.dart';
import '../../models/income.dart';
import 'base_dao.dart';

class IncomeDao implements BaseDao<Income> {
  final Database _database;
  
  @override
  String get tableName => 'incomes';
  
  @override
  Database get database => _database;

  IncomeDao(this._database);

  @override
  Future<void> insert(Income income) async {
    await database.insert(
      tableName,
      {
        'id': income.id,
        'amount': income.amount,
        'date': income.date.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Income>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query(tableName);
    return maps.map(_mapToIncome).toList();
  }

  @override
  Future<Income?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _mapToIncome(maps.first);
  }

  @override
  Future<void> update(Income income) async {
    await database.update(
      tableName,
      {
        'amount': income.amount,
        'date': income.date.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Income _mapToIncome(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      amount: map['amount'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
