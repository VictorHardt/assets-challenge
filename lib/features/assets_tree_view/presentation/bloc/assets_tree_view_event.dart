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
