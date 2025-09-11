import 'package:sqflite/sqflite.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/category/category.dart';
import 'package:advanced_shopping_list_frontend/core/services/local_shopping_list_service.dart';

class CategoryService {
  static const String _tableName = 'categories';
  final LocalShoppingListService _localService = LocalShoppingListService();

  // Get database instance from the local shopping list service
  Future<Database> get database async {
    return await _localService.database;
  }

  // Insert or update categories from API
  Future<void> saveCategories(List<Category> categories) async {
    try {
      print("🔄 CategoryService: Saving ${categories.length} categories...");
      final db = await database;
      final batch = db.batch();

      // Clear existing categories and insert new ones
      print("🔄 CategoryService: Clearing existing categories...");
      batch.delete(_tableName);
      
      print("🔄 CategoryService: Inserting new categories...");
      for (final category in categories) {
        batch.insert(_tableName, category.toDbMap());
      }

      await batch.commit(noResult: true);
      print("✅ CategoryService: Categories saved successfully");
    } catch (e) {
      print("❌ CategoryService: Error saving categories: $e");
      rethrow;
    }
  }

  // Get all categories from local database
  Future<List<Category>> getAllCategories() async {
    try {
      print("🔄 CategoryService: Getting database instance...");
      final db = await database;
      print("🔄 CategoryService: Querying categories table...");
      final maps = await db.query(
        _tableName,
        orderBy: 'name ASC',
      );
      print("✅ CategoryService: Found ${maps.length} categories in database");
      return maps.map((map) => CategoryDb.fromDbMap(map)).toList();
    } catch (e) {
      print("❌ CategoryService: Error getting categories: $e");
      rethrow;
    }
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CategoryDb.fromDbMap(maps.first);
    }
    return null;
  }

  // Get category by name
  Future<Category?> getCategoryByName(String name) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return CategoryDb.fromDbMap(maps.first);
    }
    return null;
  }

  // Check if categories table is empty
  Future<bool> isEmpty() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    final count = result.first['count'] as int;
    return count == 0;
  }

  // Close database - delegated to LocalShoppingListService
  Future<void> close() async {
    await _localService.close();
  }
}
