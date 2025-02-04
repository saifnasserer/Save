// Database name and version
const String kDatabaseName = 'save.db';
const int kDatabaseVersion = 2;

// Table names
const String kMemoTable = 'memos';
const String kNotificationTable = 'notifications';

// Common column names
const String kColumnId = 'id';
const String kColumnTitle = 'title';
const String kColumnContent = 'content';
const String kColumnCreatedAt = 'created_at';
const String kColumnModifiedAt = 'modified_at';
const String kColumnIsPinned = 'is_pinned';
const String kColumnCategory = 'category';

// Notification column names
const String kColumnMemoId = 'memo_id';
const String kColumnNotificationTime = 'notification_time';
const String kColumnIsCompleted = 'is_completed';

// Create table queries
const String kCreateMemoTable = '''
  CREATE TABLE $kMemoTable (
    $kColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $kColumnTitle TEXT NOT NULL,
    $kColumnContent TEXT,
    $kColumnCreatedAt TEXT NOT NULL,
    $kColumnModifiedAt TEXT NOT NULL,
    $kColumnIsPinned INTEGER DEFAULT 0,
    $kColumnCategory TEXT
  )
''';

const String kCreateNotificationTable = '''
  CREATE TABLE $kNotificationTable (
    $kColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $kColumnMemoId INTEGER NOT NULL,
    $kColumnNotificationTime TEXT NOT NULL,
    $kColumnIsCompleted INTEGER DEFAULT 0,
    FOREIGN KEY ($kColumnMemoId) REFERENCES $kMemoTable ($kColumnId) ON DELETE CASCADE
  )
''';
