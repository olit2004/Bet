import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/seller_property_model.dart';

class SellerPropertyLocalDataSource {
  final DatabaseHelper _databaseHelper;

  SellerPropertyLocalDataSource({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  Future<void> cacheSellerProperties(
      String sellerId, List<SellerPropertyModel> properties) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    // Clear existing properties for this seller
    batch.delete('seller_properties',
        where: 'ownerId = ?', whereArgs: [sellerId]);

    // Insert new properties
    for (var property in properties) {
      batch.insert(
        'seller_properties',
        {
          'id': property.id,
          'ownerId': property.ownerId,
          'data': jsonEncode(property.toJson()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> cacheProperty(SellerPropertyModel property) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'seller_properties',
      {
        'id': property.id,
        'ownerId': property.ownerId,
        'data': jsonEncode(property.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SellerPropertyModel>> getSellerProperties(String sellerId) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'seller_properties',
      where: 'ownerId = ?',
      whereArgs: [sellerId],
    );

    if (maps.isEmpty) {
      return [];
    }

    final properties = <SellerPropertyModel>[];
    for (var map in maps) {
      try {
        final data = jsonDecode(map['data'] as String) as Map<String, dynamic>;
        properties.add(SellerPropertyModel.fromJson(data));
      } catch (e) {
        // Skip corrupted or incompatible cache entries
      }
    }
    return properties;
  }

  Future<SellerPropertyModel?> getPropertyById(String propertyId) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'seller_properties',
      where: 'id = ?',
      whereArgs: [propertyId],
    );

    if (maps.isEmpty) {
      return null;
    }

    try {
      final data = jsonDecode(maps.first['data'] as String) as Map<String, dynamic>;
      return SellerPropertyModel.fromJson(data);
    } catch (e) {
      return null; // Return null if cache is corrupted
    }
  }
}
