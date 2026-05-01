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
}
