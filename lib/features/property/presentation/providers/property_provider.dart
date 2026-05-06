import 'package:flutter/material.dart';
import '../../domain/models/property_model.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyRepository _repository;

  PropertyProvider({required PropertyRepository repository}) : _repository = repository;

  List<Property> _properties = [];
  bool _isLoading = false;
  PropertyCategory? _selectedCategory;
  String? _errorMessage;

  List<Property> get properties => _properties;
  bool get isLoading => _isLoading;
  PropertyCategory? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

  /// Fetches the list of properties from the repository
  Future<void> loadProperties() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _properties = await _repository.getProperties();
    } catch (e) {
      _errorMessage = 'Failed to load properties. Please try again.';
      _properties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Searches properties based on a query string
  Future<void> searchProperties(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (query.trim().isEmpty) {
        if (_selectedCategory != null) {
          _properties = await _repository.getPropertiesByCategory(_selectedCategory!);
        } else {
          _properties = await _repository.getProperties();
        }
      } else {
        _properties = await _repository.searchProperties(query);
        // Clear category selection when searching to avoid confusion
        _selectedCategory = null;
      }
    } catch (e) {
      _errorMessage = 'Search failed. Please try again.';
      _properties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filters properties by a specific category
  Future<void> filterByCategory(PropertyCategory? category) async {
    _selectedCategory = category;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (category == null) {
        _properties = await _repository.getProperties();
      } else {
        _properties = await _repository.getPropertiesByCategory(category);
      }
    } catch (e) {
      _errorMessage = 'Filtering failed. Please try again.';
      _properties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches a single property by ID
  Future<Property?> getPropertyById(String id) async {
    try {
      return await _repository.getPropertyById(id);
    } catch (e) {
      return null;
    }
  }

  /// Clears all filters and reloads all properties
  Future<void> clearFilters() async {
    _selectedCategory = null;
    await loadProperties();
  }
}
