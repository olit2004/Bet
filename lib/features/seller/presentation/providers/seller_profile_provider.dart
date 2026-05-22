import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/seller_profile_stats.dart';
import '../../domain/repositories/seller_profile_repository.dart';
import '../../data/data_sources/seller_profile_remote_data_source.dart';
import '../../data/repositories/seller_profile_repository_impl.dart';
import '../../../auth/application/providers/auth_provider.dart';

// Dependency Injection

final sellerProfileRemoteDataSourceProvider = Provider<SellerProfileRemoteDataSource>((ref) {
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  return SellerProfileRemoteDataSource(authLocalDataSource: authLocalDataSource);
});

final sellerProfileRepositoryProvider = Provider<SellerProfileRepository>((ref) {
  return SellerProfileRepositoryImpl(
    remoteDataSource: ref.watch(sellerProfileRemoteDataSourceProvider),
  );
});

// Future Provider to fetch the seller's stats
final sellerProfileStatsProvider = FutureProvider.family<SellerProfileStats, String>((ref, sellerId) async {
  final repository = ref.watch(sellerProfileRepositoryProvider);
  return await repository.getSellerStats(sellerId);
});
