class SqfliteV1 {
  SqfliteV1._();

  static const categoriesTb = '''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''';

  static const tasksTb = '''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        priority TEXT NOT NULL,
        task_date TEXT NOT NULL,
        is_complete INTEGER NOT NULL,
        completed_at TEXT,
        reminder_date TEXT,
        task_repeat TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''';
}
