// Database name and version
const String kDatabaseName = 'save.db';
const int kDatabaseVersion = 1;

// Table names
const String kMemoTable = 'memos';

// Common column names
const String kColumnId = 'id';
const String kColumnTitle = 'title';
const String kColumnContent = 'content';
const String kColumnCreatedAt = 'created_at';
const String kColumnModifiedAt = 'modified_at';
const String kColumnIsPinned = 'is_pinned';
const String kColumnCategory = 'category';

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
