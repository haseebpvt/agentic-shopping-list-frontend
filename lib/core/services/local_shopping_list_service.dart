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
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // Create database tables
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_name TEXT NOT NULL,
        note TEXT NOT NULL,
        quantity TEXT NOT NULL,
        unit TEXT NOT NULL,
        category_name TEXT NOT NULL,
        is_purchased INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');
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

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
