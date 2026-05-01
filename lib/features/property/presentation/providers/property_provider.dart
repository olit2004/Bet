import 'package:flutter/material.dart';
import '../../domain/models/property_model.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyRepository _repository;

  PropertyProvider({required PropertyRepository repository}) : _repository = repository;

  List<Property> _properties = [];
  bool _isLoading = false;

  List<Property> get properties => _properties;
  bool get isLoading => _isLoading;

  /// Fetches the list of properties from the repository
  Future<void> loadProperties() async {
    _isLoading = true;
    notifyListeners();

    try {
      _properties = await _repository.getProperties();
    } catch (e) {
      // In a real app, you might want to handle errors (e.g., set an error message state)
      _properties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Searches properties based on a query string
  Future<void> searchProperties(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (query.trim().isEmpty) {
        _properties = await _repository.getProperties();
      } else {
        _properties = await _repository.searchProperties(query);
      }
    } catch (e) {
      _properties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filters properties by a specific category
  Future<void> filterByCategory(PropertyCategory category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _properties = await _repository.getPropertiesByCategory(category);
    } catch (e) {
      _properties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
