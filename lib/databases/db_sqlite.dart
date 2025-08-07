import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/databases/sqflite_version/sqflite_v1.dart';

class DatabaseSqlite {
  static Database? _db;
  static final DatabaseSqlite instance = DatabaseSqlite._contructor();
  DatabaseSqlite._contructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, 'master_db.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );

    // debugPrint('Created database at $dbPath');
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(SqfliteV1.categoriesTb);
    await db.execute(SqfliteV1.tasksTb);
  }
}
