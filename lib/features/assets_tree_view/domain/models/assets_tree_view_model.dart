import 'package:assets_challenge/features/assets_tree_view/domain/models/asset_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/location_model.dart';
import 'package:equatable/equatable.dart';

class AssetTreeViewModel extends Equatable {
  final List<LocationModel> locations;
  final List<AssetModel> assets;
  const AssetTreeViewModel({
    required this.locations,
    required this.assets,
  });

  @override
  List<Object> get props => [
        locations,
        assets,
      ];
}
