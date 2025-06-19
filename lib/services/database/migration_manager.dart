import 'package:sqflite_common/sqlite_api.dart';

class DatabaseMigrationManager {
  static const int currentVersion = 1;

  final Map<int, List<String>> _migrations = {
    1: [
      '''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        amount REAL,
        transaction_date INTEGER NOT NULL,
        settlement_date INTEGER
      )
      ''',
      '''
      CREATE TABLE incomes (
        id TEXT PRIMARY KEY,
        amount REAL,
        date INTEGER NOT NULL
      )
      '''
    ],
    // 새로운 버전의 마이그레이션을 추가할 때는 아래와 같이 추가합니다:
    // 2: [
    //   'ALTER TABLE expenses ADD COLUMN category TEXT',
    //   'CREATE INDEX idx_expense_date ON expenses(transaction_date)'
    // ],
  };

  /// 데이터베이스 생성 시 호출되는 메서드
  Future<void> onCreate(Database db, int version) async {
    // 버전 1의 스키마 생성
    final migrations = _migrations[1] ?? [];
    for (final sql in migrations) {
      await db.execute(sql);
    }
  }

  /// 데이터베이스 업그레이드 시 호출되는 메서드
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    // oldVersion부터 newVersion까지 순차적으로 마이그레이션 실행
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      final migrations = _migrations[i] ?? [];
      for (final sql in migrations) {
        await db.execute(sql);
      }
    }
  }

  /// 데이터베이스 다운그레이드 시 호출되는 메서드 (옵션)
  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    // 기본적으로는 데이터베이스를 삭제하고 다시 생성하는 것이 안전합니다.
    throw UnsupportedError(
      '데이터베이스 다운그레이드는 지원하지 않습니다. 앱을 재설치해주세요.',
    );
  }

  /// 특정 버전의 마이그레이션 스크립트 가져오기
  List<String> getMigrationScripts(int version) {
    return _migrations[version] ?? [];
  }

  /// 새로운 마이그레이션 스크립트 추가
  void addMigration(int version, List<String> scripts) {
    if (version <= currentVersion) {
      throw ArgumentError('이미 존재하는 버전에는 마이그레이션을 추가할 수 없습니다.');
    }
    _migrations[version] = scripts;
  }
}
