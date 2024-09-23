part of 'assets_tree_view_bloc.dart';

sealed class AssetsTreeViewEvent extends Equatable {
  const AssetsTreeViewEvent();

  @override
  List<Object> get props => [];
}

final class GetCompanies extends AssetsTreeViewEvent {
  const GetCompanies();

  @override
  List<Object> get props => [];
}

final class GetlocationsAndAssets extends AssetsTreeViewEvent {
  final String companyId;

  const GetlocationsAndAssets({
    required this.companyId,
  });

  @override
  List<Object> get props => [companyId];
}

final class FilterEnergyAssets extends AssetsTreeViewEvent {
  const FilterEnergyAssets();

  @override
  List<Object> get props => [];
}

final class FilterCriticalStatusAssets extends AssetsTreeViewEvent {
  const FilterCriticalStatusAssets();

  @override
  List<Object> get props => [];
}

final class SearchAssetsAndLocationsByName extends AssetsTreeViewEvent {
  final String query;

  const SearchAssetsAndLocationsByName({
    required this.query,
  });

  @override
  List<Object> get props => [query];
}

final class RemoveSearchAssetsAndLocationsByName extends AssetsTreeViewEvent {
  const RemoveSearchAssetsAndLocationsByName();

  @override
  List<Object> get props => [];
}
