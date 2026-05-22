import '../models/property_model.dart';
import './property_repository.dart';
import '../data_sources/mock_property_data.dart';
import '../data_sources/property_remote_data_source.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource _remoteDataSource = PropertyRemoteDataSource();

  @override
  Future<List<Property>> getProperties() async {
    try {
      return await _remoteDataSource.getProperties();
    } catch (_) {
      // Fallback to mock data if the server is unreachable
      return MockPropertyData.properties;
    }
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    try {
      return await _remoteDataSource.getPropertyById(id);
    } catch (_) {
      try {
        return MockPropertyData.properties.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<List<Property>> searchProperties(String query) async {
    final all = await getProperties();
    final lowercaseQuery = query.toLowerCase();
    return all.where((p) {
      return p.title.toLowerCase().contains(lowercaseQuery) ||
             p.address.toLowerCase().contains(lowercaseQuery) ||
             p.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<Property>> getPropertiesByCategory(PropertyCategory category) async {
    final all = await getProperties();
    return all.where((p) => p.category == category).toList();
  }
}
