import '../../domain/models/property_model.dart';
import '../../domain/repositories/property_repository.dart';
import '../data_sources/mock_property_data.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  @override
  Future<List<Property>> getProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockPropertyData.properties;
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return MockPropertyData.properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Property>> searchProperties(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lowercaseQuery = query.toLowerCase();
    return MockPropertyData.properties.where((p) {
      return p.title.toLowerCase().contains(lowercaseQuery) ||
             p.address.toLowerCase().contains(lowercaseQuery) ||
             p.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<Property>> getPropertiesByCategory(PropertyCategory category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockPropertyData.properties.where((p) => p.category == category).toList();
  }
}
