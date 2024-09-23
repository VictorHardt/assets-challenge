part of 'assets_tree_view_bloc.dart';

sealed class AssetsTreeViewState extends Equatable {
  const AssetsTreeViewState();

  @override
  List<Object> get props => [];
}

final class AssetsTreeViewInitial extends AssetsTreeViewState {}

final class AssetsTreeViewSuccess extends AssetsTreeViewState {
  final List<CompaniesModel> companies;
  final List<AssetTreeViewModel> assetsTreeViews;

  const AssetsTreeViewSuccess({
    required this.companies,
    required this.assetsTreeViews,
  });

  @override
  List<Object> get props => [
        companies,
        assetsTreeViews,
      ];
}

final class AssetsTreeViewLoading extends AssetsTreeViewState {}

class AssetsTreeViewFailure extends AssetsTreeViewState {
  final String message;

  const AssetsTreeViewFailure({required this.message});
  @override
  List<Object> get props => [message];
}
