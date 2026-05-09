import '../models/property_model.dart';

abstract class PropertyRepository {
  /// Fetches all available properties
  Future<List<Property>> getProperties();

  /// Fetches a single property by its unique ID
  Future<Property?> getPropertyById(String id);

  /// Searches for properties based on a query string (title, address, etc.)
  Future<List<Property>> searchProperties(String query);

  /// Filters properties by category
  Future<List<Property>> getPropertiesByCategory(PropertyCategory category);
}
