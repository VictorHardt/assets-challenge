part of 'assets_tree_view_bloc.dart';

sealed class AssetsTreeViewState extends Equatable {
  const AssetsTreeViewState();

  @override
  List<Object> get props => [];
}

final class AssetsTreeViewInitial extends AssetsTreeViewState {}

final class AssetsTreeViewSuccess extends AssetsTreeViewState {
  final List<CompaniesModel> companies;

  const AssetsTreeViewSuccess({
    required this.companies,
  });

  @override
  List<Object> get props => [
        companies,
      ];
}

final class AssetsTreeViewLoading extends AssetsTreeViewState {}

class AssetsTreeViewFailure extends AssetsTreeViewState {
  final String message;

  const AssetsTreeViewFailure({required this.message});
  @override
  List<Object> get props => [message];
}
