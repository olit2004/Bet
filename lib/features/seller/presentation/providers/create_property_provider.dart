import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/seller_property.dart';
import '../../domain/repositories/seller_property_repository.dart';
import '../../data/data_sources/seller_property_remote_data_source.dart';
import '../../data/data_sources/seller_property_local_data_source.dart';
import '../../data/repositories/seller_property_repository_impl.dart';
import '../../../../core/database/database_helper.dart';
import '../../../auth/application/providers/auth_provider.dart';
import 'seller_properties_provider.dart';
import 'seller_profile_provider.dart';
import 'property_detail_provider.dart';

// Dependency Injection Providers ---

final sellerPropertyRemoteDataSourceProvider =
    Provider<SellerPropertyRemoteDataSource>((ref) {
      return SellerPropertyRemoteDataSource(
        authLocalDataSource: ref.watch(authLocalDataSourceProvider),
      );
    });

final sellerPropertyLocalDataSourceProvider =
    Provider<SellerPropertyLocalDataSource>((ref) {
      return SellerPropertyLocalDataSource(
        databaseHelper: DatabaseHelper(),
      );
    });

final sellerPropertyRepositoryProvider = Provider<SellerPropertyRepository>((
  ref,
) {
  return SellerPropertyRepositoryImpl(
    remoteDataSource: ref.watch(sellerPropertyRemoteDataSourceProvider),
    localDataSource: ref.watch(sellerPropertyLocalDataSourceProvider),
  );
});

// State Management

enum CreatePropertyStatus { initial, loading, success, error }

class CreatePropertyState {
  final CreatePropertyStatus status;
  final SellerProperty? createdProperty;
  final String? errorMessage;

  const CreatePropertyState({
    required this.status,
    this.createdProperty,
    this.errorMessage,
  });

  const CreatePropertyState.initial()
    : status = CreatePropertyStatus.initial,
      createdProperty = null,
      errorMessage = null;

  CreatePropertyState copyWith({
    CreatePropertyStatus? status,
    SellerProperty? createdProperty,
    String? errorMessage,
  }) {
    return CreatePropertyState(
      status: status ?? this.status,
      createdProperty: createdProperty ?? this.createdProperty,
      errorMessage: errorMessage,
    );
  }
}

class CreatePropertyNotifier extends Notifier<CreatePropertyState> {
  SellerPropertyRepository get _repository =>
      ref.read(sellerPropertyRepositoryProvider);

  @override
  CreatePropertyState build() {
    return const CreatePropertyState.initial();
  }

  /// Resets the state back to initial (e.g., when navigating away).
  void reset() {
    state = const CreatePropertyState.initial();
  }

  //Submits a new property listing to the backend.
  Future<bool> createProperty(Map<String, dynamic> propertyData) async {
    state = state.copyWith(
      status: CreatePropertyStatus.loading,
      errorMessage: null,
    );

    try {
      final property = await _repository.createProperty(propertyData);
      state = state.copyWith(
        status: CreatePropertyStatus.success,
        createdProperty: property,
      );

      // Invalidate the seller's properties list to force a refresh
      ref.invalidate(sellerPropertiesProvider);
      // Invalidate the seller's profile stats to update the counts in the profile tab
      ref.invalidate(sellerProfileStatsProvider);

      return true;
    } catch (e) {
      String message = 'Something went wrong. Please try again.';
      if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      }
      state = state.copyWith(
        status: CreatePropertyStatus.error,
        errorMessage: message,
      );
      return false;
    }
  }

  Future<bool> updateProperty(String propertyId, Map<String, dynamic> propertyData) async {
    state = state.copyWith(
      status: CreatePropertyStatus.loading,
      errorMessage: null,
    );

    try {
      final property = await _repository.updateProperty(propertyId, propertyData);
      state = state.copyWith(
        status: CreatePropertyStatus.success,
        createdProperty: property,
      );

      final sellerId = property.ownerId;
      ref.invalidate(sellerPropertiesProvider(sellerId));
      ref.invalidate(propertyDetailProvider(propertyId));

      return true;
    } catch (e) {
      String message = 'Something went wrong. Please try again.';
      if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      }
      state = state.copyWith(
        status: CreatePropertyStatus.error,
        errorMessage: message,
      );
      return false;
    }
  }

  Future<bool> deleteProperty(String propertyId) async {
    state = state.copyWith(
      status: CreatePropertyStatus.loading,
      errorMessage: null,
    );

    try {
      await _repository.deleteProperty(propertyId);
      state = state.copyWith(
        status: CreatePropertyStatus.success,
        createdProperty: null,
      );

      final userId = ref.read(authNotifierProvider).user?.id;
      if (userId != null) {
        ref.invalidate(sellerPropertiesProvider(userId));
      }
      ref.invalidate(propertyDetailProvider(propertyId));

      return true;
    } catch (e) {
      String message = 'Something went wrong. Please try again.';
      if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      }
      state = state.copyWith(
        status: CreatePropertyStatus.error,
        errorMessage: message,
      );
      return false;
    }
  }
}

final createPropertyNotifierProvider =
    NotifierProvider<CreatePropertyNotifier, CreatePropertyState>(() {
      return CreatePropertyNotifier();
    });
