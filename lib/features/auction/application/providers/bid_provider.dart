import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bid_entity.dart';
import '../../domain/repositories/bid_repository.dart';
import '../../infrastructure/data_sources/bid_local_data_source.dart';
import '../../infrastructure/data_sources/bid_remote_data_source.dart';
import '../../infrastructure/repositories/bid_repository_impl.dart';
import '../../../../core/database/database_helper.dart';
import '../../../auth/application/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

// --- Dependency Injection Providers ---

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final bidLocalDataSourceProvider = Provider<BidLocalDataSource>((ref) {
  return BidLocalDataSourceImpl(ref.watch(databaseHelperProvider));
});

final bidRemoteDataSourceProvider = Provider<BidRemoteDataSource>((ref) {
  return BidRemoteDataSourceImpl(client: ref.watch(httpClientProvider));
});

final bidRepositoryProvider = Provider<BidRepository>((ref) {
  return BidRepositoryImpl(
    localDataSource: ref.watch(bidLocalDataSourceProvider),
    remoteDataSource: ref.watch(bidRemoteDataSourceProvider),
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// --- State Management ---

enum BidStatus { initial, loading, success, error }

class BidStateData {
  final BidStatus status;
  final List<BidEntity> bids;
  final String? errorMessage;

  BidStateData({
    required this.status,
    this.bids = const [],
    this.errorMessage,
  });

  BidStateData copyWith({
    BidStatus? status,
    List<BidEntity>? bids,
    String? errorMessage,
  }) {
    return BidStateData(
      status: status ?? this.status,
      bids: bids ?? this.bids,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BidNotifier extends Notifier<BidStateData> {
  BidRepository get _repository => ref.read(bidRepositoryProvider);

  @override
  BidStateData build() {
    return BidStateData(status: BidStatus.initial);
  }

  Future<void> fetchPropertyBids(String propertyId) async {
    state = state.copyWith(status: BidStatus.loading, errorMessage: null);
    try {
      final bids = await _repository.getPropertyBids(propertyId);
      state = state.copyWith(status: BidStatus.success, bids: bids);
    } catch (e) {
      state = state.copyWith(status: BidStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> placeBid(String propertyId, double amount, {List<int>? bankStatementBytes, String? bankStatementFileName}) async {
    state = state.copyWith(status: BidStatus.loading, errorMessage: null);
    try {
      final newBid = await _repository.placeBid(propertyId, amount, bankStatementBytes: bankStatementBytes, bankStatementFileName: bankStatementFileName);
      state = state.copyWith(
        status: BidStatus.success,
        bids: [...state.bids, newBid],
      );
    } catch (e) {
      state = state.copyWith(status: BidStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> acceptBid(String bidId) async {
    state = state.copyWith(status: BidStatus.loading, errorMessage: null);
    try {
      final updatedBid = await _repository.acceptBid(bidId);
      final updatedBids = state.bids.map((b) => b.id == bidId ? updatedBid : b).toList();
      state = state.copyWith(status: BidStatus.success, bids: updatedBids);
    } catch (e) {
      state = state.copyWith(status: BidStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> retractBid(String bidId) async {
    state = state.copyWith(status: BidStatus.loading, errorMessage: null);
    try {
      final updatedBid = await _repository.retractBid(bidId);
      final updatedBids = state.bids.map((b) => b.id == bidId ? updatedBid : b).toList();
      state = state.copyWith(status: BidStatus.success, bids: updatedBids);
    } catch (e) {
      state = state.copyWith(status: BidStatus.error, errorMessage: e.toString());
    }
  }
}

final bidNotifierProvider = NotifierProvider<BidNotifier, BidStateData>(() {
  return BidNotifier();
});
