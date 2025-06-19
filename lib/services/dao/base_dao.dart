import 'package:sqflite_common/sqlite_api.dart';

abstract class BaseDao<T> {
  Future<void> insert(T item);
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<void> update(T item);
  Future<void> delete(String id);
  
  String get tableName;
  Database get database;
}
