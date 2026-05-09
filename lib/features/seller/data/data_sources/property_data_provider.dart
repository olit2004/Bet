abstract class PropertyDataProvider {
  /// Fetches raw property data as a list of maps
  Future<List<Map<String, dynamic>>> getRawProperties();

  /// Fetches raw data for a single property by its ID
  Future<Map<String, dynamic>?> getRawPropertyById(String id);

  /// Searches for properties based on a query string
  Future<List<Map<String, dynamic>>> searchRawProperties(String query);
}
