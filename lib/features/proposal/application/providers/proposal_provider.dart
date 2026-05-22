import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/proposal_entity.dart';
import '../../domain/repositories/proposal_repository.dart';
import '../../infrastructure/data_sources/proposal_local_data_source.dart';
import '../../infrastructure/data_sources/proposal_remote_data_source.dart';
import '../../infrastructure/repositories/proposal_repository_impl.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../auction/application/providers/bid_provider.dart'; // to reuse httpClientProvider & databaseHelperProvider

// --- Dependency Injection Providers ---

final proposalLocalDataSourceProvider = Provider<ProposalLocalDataSource>((ref) {
  return ProposalLocalDataSourceImpl(ref.watch(databaseHelperProvider));
});

final proposalRemoteDataSourceProvider = Provider<ProposalRemoteDataSource>((ref) {
  return ProposalRemoteDataSourceImpl(client: ref.watch(httpClientProvider));
});

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  return ProposalRepositoryImpl(
    localDataSource: ref.watch(proposalLocalDataSourceProvider),
    remoteDataSource: ref.watch(proposalRemoteDataSourceProvider),
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// --- State Management ---

enum ProposalStatus { initial, loading, success, error }

class ProposalStateData {
  final ProposalStatus status;
  final List<ProposalEntity> proposals;
  final String? errorMessage;

  ProposalStateData({
    required this.status,
    this.proposals = const [],
    this.errorMessage,
  });

  ProposalStateData copyWith({
    ProposalStatus? status,
    List<ProposalEntity>? proposals,
    String? errorMessage,
  }) {
    return ProposalStateData(
      status: status ?? this.status,
      proposals: proposals ?? this.proposals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProposalNotifier extends Notifier<ProposalStateData> {
  ProposalRepository get _repository => ref.read(proposalRepositoryProvider);

  @override
  ProposalStateData build() {
    return ProposalStateData(status: ProposalStatus.initial);
  }

  Future<void> fetchMyProposals() async {
    state = state.copyWith(status: ProposalStatus.loading, errorMessage: null);
    try {
      final proposals = await _repository.getMyProposals();
      state = state.copyWith(status: ProposalStatus.success, proposals: proposals);
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> fetchPropertyProposals(String propertyId) async {
    state = state.copyWith(status: ProposalStatus.loading, errorMessage: null);
    try {
      final proposals = await _repository.getProposalsByProperty(propertyId);
      state = state.copyWith(status: ProposalStatus.success, proposals: proposals);
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> createProposal(String propertyId, {String? proposalFilePath}) async {
    state = state.copyWith(status: ProposalStatus.loading, errorMessage: null);
    try {
      final newProposal = await _repository.createProposal(propertyId, proposalFilePath: proposalFilePath);
      state = state.copyWith(
        status: ProposalStatus.success,
        proposals: [...state.proposals, newProposal],
      );
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> updateProposalStatus(String proposalId, String newStatus) async {
    state = state.copyWith(status: ProposalStatus.loading, errorMessage: null);
    try {
      final updatedProposal = await _repository.updateProposalStatus(proposalId, newStatus);
      final updatedList = state.proposals.map((p) => p.id == proposalId ? updatedProposal : p).toList();
      state = state.copyWith(status: ProposalStatus.success, proposals: updatedList);
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }
}

final proposalNotifierProvider = NotifierProvider<ProposalNotifier, ProposalStateData>(() {
  return ProposalNotifier();
});
