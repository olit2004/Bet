import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/buyer_dashboard.dart';
import '../../domain/repositories/buyer_repository.dart';
import '../../infrastructure/data_sources/buyer_remote_data_source.dart';
import '../../infrastructure/repositories/buyer_repository_impl.dart';
import '../../../auth/application/providers/auth_provider.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final buyerRemoteDataSourceProvider = Provider<BuyerRemoteDataSource>((ref) {
  return BuyerRemoteDataSourceImpl(client: ref.watch(httpClientProvider));
});

final buyerRepositoryProvider = Provider<BuyerRepository>((ref) {
  return BuyerRepositoryImpl(
    remoteDataSource: ref.watch(buyerRemoteDataSourceProvider),
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final buyerDashboardProvider = FutureProvider<BuyerDashboard>((ref) async {
  final repository = ref.watch(buyerRepositoryProvider);
  return repository.getBuyerDashboard();
});
