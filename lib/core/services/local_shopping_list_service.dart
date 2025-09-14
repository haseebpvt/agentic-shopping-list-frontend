import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/local_shopping_list/local_shopping_list.dart';

class LocalShoppingListService {
  static Database? _database;
  static const String _tableName = 'local_shopping_list_items';

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'shopping_list.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  // Create database tables
  Future<void> _createDatabase(Database db, int version) async {
    // Create the shopping list items table
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_name TEXT NOT NULL,
        note TEXT NOT NULL,
        quantity TEXT NOT NULL,
        unit TEXT NOT NULL,
        category_name TEXT NOT NULL,
        category_id INTEGER,
        is_purchased INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');

    // Create categories table if we're at version 2
    if (version >= 2) {
      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL UNIQUE
        )
      ''');
    }
  }

  // Upgrade database to add categories table and category_id column
  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add categories table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL UNIQUE
        )
      ''');
    }
    
    if (oldVersion < 3) {
      // Add category_id column to existing items table
      await db.execute('''
        ALTER TABLE $_tableName ADD COLUMN category_id INTEGER
      ''');
    }
  }

  // Insert new item
  Future<LocalShoppingListItem> insertItem(LocalShoppingListItem item) async {
    final db = await database;
    final id = await db.insert(_tableName, item.toDbMap());
    
    return item.copyWith(id: id);
  }

  // Get all items
  Future<List<LocalShoppingListItem>> getAllItems() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => LocalShoppingListItem.fromDbMap(map)).toList();
  }

  // Update item
  Future<LocalShoppingListItem> updateItem(LocalShoppingListItem item) async {
    final db = await database;
    final updatedItem = item.copyWith(updatedAt: DateTime.now());
    
    await db.update(
      _tableName,
      updatedItem.toDbMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    return updatedItem;
  }

  // Delete item
  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Mark item as purchased/unpurchased
  Future<LocalShoppingListItem> togglePurchased(int id, bool isPurchased) async {
    final db = await database;
    final now = DateTime.now();
    
    await db.update(
      _tableName,
      {
        'is_purchased': isPurchased ? 1 : 0,
        'updated_at': now.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Get the updated item
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return LocalShoppingListItem.fromDbMap(maps.first);
  }

  // Clear all purchased items
  Future<void> clearPurchasedItems() async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'is_purchased = ?',
      whereArgs: [1],
    );
  }

  // Get items by category
  Future<List<LocalShoppingListItem>> getItemsByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'category_name = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => LocalShoppingListItem.fromDbMap(map)).toList();
  }

  // Get items without category IDs (for background processing)
  Future<List<LocalShoppingListItem>> getItemsWithoutCategoryId() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'category_id IS NULL',
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => LocalShoppingListItem.fromDbMap(map)).toList();
  }

  // Update item's category ID
  Future<LocalShoppingListItem> updateItemCategoryId(int itemId, int categoryId, String categoryName) async {
    final db = await database;
    final now = DateTime.now();
    
    await db.update(
      _tableName,
      {
        'category_id': categoryId,
        'category_name': categoryName,
        'updated_at': now.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [itemId],
    );

    // Get the updated item
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [itemId],
    );

    return LocalShoppingListItem.fromDbMap(maps.first);
  }

  // Store category in local database
  Future<void> storeCategory(int categoryId, String categoryName) async {
    final db = await database;
    
    await db.insert(
      'categories',
      {'id': categoryId, 'name': categoryName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
