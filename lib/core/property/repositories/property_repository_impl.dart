import '../models/property_model.dart';
import './property_repository.dart';
import '../data_sources/property_remote_data_source.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource _remoteDataSource = PropertyRemoteDataSource();

  @override
  Future<List<Property>> getProperties() async {
    return await _remoteDataSource.getProperties();
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    return await _remoteDataSource.getPropertyById(id);
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
