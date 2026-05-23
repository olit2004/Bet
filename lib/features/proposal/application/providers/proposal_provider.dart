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

enum ProposalAction { none, fetch, create, update }
enum ProposalStatus { initial, loading, success, error }

class ProposalStateData {
  final ProposalStatus status;
  final ProposalAction lastAction;
  final List<ProposalEntity> proposals;
  final String? errorMessage;

  ProposalStateData({
    required this.status,
    this.lastAction = ProposalAction.none,
    this.proposals = const [],
    this.errorMessage,
  });

  ProposalStateData copyWith({
    ProposalStatus? status,
    ProposalAction? lastAction,
    List<ProposalEntity>? proposals,
    String? errorMessage,
  }) {
    return ProposalStateData(
      status: status ?? this.status,
      lastAction: lastAction ?? this.lastAction,
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
    state = state.copyWith(status: ProposalStatus.loading, lastAction: ProposalAction.fetch, errorMessage: null);
    try {
      final proposals = await _repository.getMyProposals();
      state = state.copyWith(status: ProposalStatus.success, proposals: proposals);
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> fetchPropertyProposals(String propertyId) async {
    state = state.copyWith(status: ProposalStatus.loading, lastAction: ProposalAction.fetch, errorMessage: null);
    try {
      final proposals = await _repository.getProposalsByProperty(propertyId);
      state = state.copyWith(status: ProposalStatus.success, proposals: proposals);
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> createProposal(String propertyId, {String? proposalFilePath, List<int>? fileBytes, String? fileName, double? amount, String? details}) async {
    state = state.copyWith(status: ProposalStatus.loading, lastAction: ProposalAction.create, errorMessage: null);
    try {
      final newProposal = await _repository.createProposal(propertyId, proposalFilePath: proposalFilePath, fileBytes: fileBytes, fileName: fileName, amount: amount, details: details);
      state = state.copyWith(
        status: ProposalStatus.success,
        proposals: [...state.proposals, newProposal],
      );
    } catch (e) {
      state = state.copyWith(status: ProposalStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> updateProposalStatus(String proposalId, String newStatus) async {
    state = state.copyWith(status: ProposalStatus.loading, lastAction: ProposalAction.update, errorMessage: null);
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
