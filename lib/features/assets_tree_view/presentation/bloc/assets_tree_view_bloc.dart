import 'package:assets_challenge/core/exceptions/request_failure.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/asset_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/assets_tree_view_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/companies_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/location_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/repository/assets_tree_view_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assets_tree_view_event.dart';
part 'assets_tree_view_state.dart';

class AssetsTreeViewBloc
    extends Bloc<AssetsTreeViewEvent, AssetsTreeViewState> {
  final AssetsTreeViewRepository _repository;

  List<CompaniesModel> _companies = [];
  List<CompaniesModel> get companies => _companies;

  List<AssetTreeViewModel> _assetsTreeViews = [];
  List<AssetTreeViewModel> get assetsTreeViews => _assetsTreeViews;

  bool usingEnergyAssetFilter = false;
  bool usingCriticalStatusFilter = false;
  bool get usingAnyFilter =>
      usingEnergyAssetFilter || usingCriticalStatusFilter;
  List<AssetTreeViewModel> _filteredAssetTreeViews = [];
  List<AssetTreeViewModel> get filteredAssetTreeViews =>
      _filteredAssetTreeViews;

  String get _errorString => 'Erro ao carregar';

  List<AssetTreeViewModel> _generateAssetsTreeViews({
    required List<LocationModel> locations,
    required List<AssetModel> assets,
  }) {
    List<AssetTreeViewModel> treeViewModels = [];

    // get root locations
    List<LocationModel> rootLocations =
        locations.where((location) => location.parentId == null).toList();

    // loop to generate every asset tree view
    for (var rootLocation in rootLocations) {
      List<LocationModel> locationChain = _buildLocationChain(
        parentLocation: rootLocation,
        allLocations: locations,
      );

      // loop to find every asset linked to this locationChain
      List<AssetModel> allAssetsInChain = [];
      for (var location in locationChain) {
        List<AssetModel> assetsForLocation = _buildAssetChainForLocation(
          parentLocationId: location.id,
          allAssets: assets,
        );

        allAssetsInChain.addAll(assetsForLocation);
      }

      // add this asset tree view to treeViewModels
      if (allAssetsInChain.isNotEmpty || locationChain.isNotEmpty) {
        treeViewModels.add(
          AssetTreeViewModel(
            locations: locationChain,
            assets: allAssetsInChain,
          ),
        );
      }
    }

    // get all components without parent
    List<AssetModel> componentsWithoutParent =
        assets.where((asset) => asset.isComponentWithoutParent).toList();

    // add components without parent to treeViewModels
    for (var component in componentsWithoutParent) {
      treeViewModels.add(
        AssetTreeViewModel(
          locations: const [],
          assets: [component],
        ),
      );
    }

    return treeViewModels;
  }

  /// build the location chain from the parent location
  List<LocationModel> _buildLocationChain({
    required LocationModel parentLocation,
    required List<LocationModel> allLocations,
  }) {
    // get direct child sub-locations of the current parent location
    List<LocationModel> subLocations =
        allLocations.where((loc) => loc.parentId == parentLocation.id).toList();

    if (subLocations.isEmpty) {
      return [parentLocation];
    }

    // build the chain for each sub-location
    List<LocationModel> locationChain = [parentLocation];

    for (var subLocation in subLocations) {
      locationChain.addAll(
        _buildLocationChain(
          parentLocation: subLocation,
          allLocations: allLocations,
        ),
      );
    }

    return locationChain;
  }

  /// build the asset chain for the given location
  List<AssetModel> _buildAssetChainForLocation({
    required String parentLocationId,
    required List<AssetModel> allAssets,
  }) {
    // get assets that are linked to the given location
    List<AssetModel> locationAssets = allAssets
        .where(
          (asset) => asset.locationId == parentLocationId,
        )
        .toList();

    List<AssetModel> assetChain = [];

    for (var asset in locationAssets) {
      assetChain.add(asset);

      // find sub-assets and components linked to this asset
      List<AssetModel> subAssetsAndComponents = _buildSubAssetChain(
        parentAsset: asset,
        allAssets: allAssets,
      );

      assetChain.addAll(subAssetsAndComponents);
    }

    return assetChain;
  }

  /// build the sub-asset chain recursively
  List<AssetModel> _buildSubAssetChain({
    required AssetModel parentAsset,
    required List<AssetModel> allAssets,
  }) {
    // Find sub-assets and components where the parentId matches the current asset id
    List<AssetModel> subAssets = allAssets
        .where(
          (asset) => asset.parentId == parentAsset.id,
        )
        .toList();

    List<AssetModel> assetChain = [];

    for (var subAsset in subAssets) {
      assetChain.add(subAsset);

      // add sub-sub-assets or components linked to this sub-asset
      assetChain.addAll(
        _buildSubAssetChain(parentAsset: subAsset, allAssets: allAssets),
      );
    }

    return assetChain;
  }

  List<AssetTreeViewModel> filterEnergyAssets(
      List<AssetTreeViewModel> treeViewModels) {
    return treeViewModels.where((treeViewModel) {
      bool hasEnergyAsset =
          treeViewModel.assets.any((asset) => asset.isEnergyAsset);

      return hasEnergyAsset;
    }).toList();
  }

  List<AssetTreeViewModel> filterCriticalStatusAssets(
      List<AssetTreeViewModel> treeViewModels) {
    return treeViewModels.where((treeViewModel) {
      bool hasAssetInCriticalStatus =
          treeViewModel.assets.any((asset) => asset.assetInCriticalStatus);

      return hasAssetInCriticalStatus;
    }).toList();
  }

  List<AssetTreeViewModel> searchAssetsAndLocationsByName({
    required List<AssetTreeViewModel> treeViewModels,
    required String searchText,
  }) {
    String lowerSearchText = searchText.toLowerCase();

    return treeViewModels
        .map((treeViewModel) {
          // filter locations
          List<LocationModel> matchingLocations = treeViewModel.locations
              .where((location) =>
                  location.name.toLowerCase().contains(lowerSearchText))
              .toList();

          // filter assets
          List<AssetModel> matchingAssets = treeViewModel.assets
              .where(
                  (asset) => asset.name.toLowerCase().contains(lowerSearchText))
              .toList();

          // if any locations or assets match the search text, return the filtered AssetTreeViewModel
          if (matchingLocations.isNotEmpty || matchingAssets.isNotEmpty) {
            return AssetTreeViewModel(
              locations: matchingLocations.isNotEmpty
                  ? matchingLocations
                  : treeViewModel.locations,
              assets: matchingAssets,
            );
          }
          return null;
        })
        .where((treeViewModel) => treeViewModel != null)
        .cast<AssetTreeViewModel>()
        .toList();
  }

  AssetsTreeViewBloc(this._repository) : super(AssetsTreeViewInitial()) {
    on<GetCompanies>((event, emit) async {
      try {
        emit(AssetsTreeViewLoading());

        _companies = await _repository.getCompanies();

        emit(
          AssetsTreeViewSuccess(
            companies: companies,
            assetsTreeViews: assetsTreeViews,
          ),
        );
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? _errorString,
          ),
        );
      }
    });

    on<GetlocationsAndAssets>((event, emit) async {
      try {
        emit(AssetsTreeViewLoading());

        List<LocationModel> locations = await _repository.getLocations(
          companyId: event.companyId,
        );

        List<AssetModel> assets = await _repository.getAssets(
          companyId: event.companyId,
        );

        _assetsTreeViews = _generateAssetsTreeViews(
          locations: locations,
          assets: assets,
        );

        emit(
          AssetsTreeViewSuccess(
            companies: companies,
            assetsTreeViews: assetsTreeViews,
          ),
        );
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? _errorString,
          ),
        );
      }
    });

    on<FilterEnergyAssets>((event, emit) async {
      try {
        if (usingEnergyAssetFilter) {
          usingEnergyAssetFilter = !usingEnergyAssetFilter;

          emit(
            AssetsTreeViewSuccess(
              companies: companies,
              assetsTreeViews: assetsTreeViews,
            ),
          );
        } else {
          usingEnergyAssetFilter = !usingEnergyAssetFilter;

          usingCriticalStatusFilter = false;

          _filteredAssetTreeViews = filterEnergyAssets(assetsTreeViews);

          emit(
            AssetsTreeViewSuccess(
              companies: companies,
              assetsTreeViews: _filteredAssetTreeViews,
            ),
          );
        }
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? _errorString,
          ),
        );
      }
    });

    on<FilterCriticalStatusAssets>((event, emit) async {
      try {
        if (usingCriticalStatusFilter) {
          usingCriticalStatusFilter = !usingCriticalStatusFilter;

          emit(
            AssetsTreeViewSuccess(
              companies: companies,
              assetsTreeViews: assetsTreeViews,
            ),
          );
        } else {
          usingCriticalStatusFilter = !usingCriticalStatusFilter;

          usingEnergyAssetFilter = false;

          _filteredAssetTreeViews = filterCriticalStatusAssets(assetsTreeViews);

          emit(
            AssetsTreeViewSuccess(
              companies: companies,
              assetsTreeViews: _filteredAssetTreeViews,
            ),
          );
        }
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? _errorString,
          ),
        );
      }
    });

    on<SearchAssetsAndLocationsByName>((event, emit) async {
      try {
        emit(
          AssetsTreeViewSuccess(
            companies: companies,
            assetsTreeViews: searchAssetsAndLocationsByName(
              treeViewModels:
                  usingAnyFilter ? _filteredAssetTreeViews : _assetsTreeViews,
              searchText: event.query,
            ),
          ),
        );
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? _errorString,
          ),
        );
      }
    });

    on<RemoveSearchAssetsAndLocationsByName>((event, emit) async {
      try {
        emit(
          AssetsTreeViewSuccess(
            companies: companies,
            assetsTreeViews: assetsTreeViews,
          ),
        );
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? _errorString,
          ),
        );
      }
    });
  }
}
