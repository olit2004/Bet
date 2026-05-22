import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/buyer_profile.dart';
import '../domain/entities/buyer_dashboard.dart';
import '../domain/repositories/buyer_repository.dart';
import '../infrastructure/repositories/buyer_repository_impl.dart';
import '../infrastructure/data_sources/buyer_remote_data_source.dart';
import '../infrastructure/data_sources/bid_remote_data_source.dart';
import '../infrastructure/data_sources/proposal_remote_data_source.dart';

final buyerRemoteDataSourceProvider = Provider<BuyerRemoteDataSource>((ref) {
  return BuyerRemoteDataSource();
});

final buyerRepositoryProvider = Provider<BuyerRepository>((ref) {
  final remoteDataSource = ref.watch(buyerRemoteDataSourceProvider);
  return BuyerRepositoryImpl(remoteDataSource: remoteDataSource);
});

final buyerProfileProvider = FutureProvider.autoDispose<BuyerProfile>((ref) async {
  final repository = ref.watch(buyerRepositoryProvider);
  return repository.getProfile();
});

final buyerDashboardProvider = FutureProvider.autoDispose<BuyerDashboard>((ref) async {
  final repository = ref.watch(buyerRepositoryProvider);
  return repository.getDashboard();
});

// --- Bid Providers ---
final bidRemoteDataSourceProvider = Provider<BidRemoteDataSource>((ref) {
  return BidRemoteDataSource();
});

final myBidsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final dataSource = ref.watch(bidRemoteDataSourceProvider);
  return dataSource.getMyBids();
});

// --- Proposal Providers ---
final proposalRemoteDataSourceProvider = Provider<ProposalRemoteDataSource>((ref) {
  return ProposalRemoteDataSource();
});

final myProposalsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final dataSource = ref.watch(proposalRemoteDataSourceProvider);
  return dataSource.getMyProposals();
});
