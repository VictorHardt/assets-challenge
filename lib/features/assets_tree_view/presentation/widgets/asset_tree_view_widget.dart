import 'package:assets_challenge/core/utils/assets_path.dart';
import 'package:assets_challenge/design_system/tractian_colors.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/asset_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/assets_tree_view_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetTreeViewWidget extends StatefulWidget {
  final AssetTreeViewModel assetTreeView;
  const AssetTreeViewWidget({
    super.key,
    required this.assetTreeView,
  });

  @override
  AssetTreeViewWidgetState createState() => AssetTreeViewWidgetState();
}

class AssetTreeViewWidgetState extends State<AssetTreeViewWidget> {
  // track the expanded state of each node
  final Map<String, bool> _expandedState = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TractianColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: TractianColors.gray5,
            offset: Offset(0.0, 1.0),
            blurRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        // start with root locations and component without parent
        children: _buildTreeView(
          locations: widget.assetTreeView.locations
              .where((location) => location.parentId == null)
              .toList(),
          assets: widget.assetTreeView.assets
              .where(
                  (asset) => asset.parentId == null && asset.locationId == null)
              .toList(),
        ),
      ),
    );
  }

  // method to build the tree
  List<Widget> _buildTreeView({
    required List<LocationModel> locations,
    required List<AssetModel> assets,
    int level = 0, // track how deep we are in the hierarchy for padding
  }) {
    List<Widget> assetTreeView = [];

    // add locations to the tree
    for (var location in locations) {
      assetTreeView.add(
        _buildTreeNode(
          id: location.id,
          name: location.name,
          iconPath: location.iconPath,
          level: level,
          isAsset: false,
          isEnergyAsset: false,
          assetInCriticalStatus: false,
          children: _buildTreeView(
            locations: widget.assetTreeView.locations
                .where((l) => l.parentId == location.id)
                .toList(),
            assets: widget.assetTreeView.assets
                .where((a) => a.locationId == location.id && a.parentId == null)
                .toList(),
            level: level + 1,
          ),
        ),
      );
    }

    // add assets to the tree
    for (var asset in assets) {
      assetTreeView.add(
        _buildTreeNode(
          id: asset.id,
          name: asset.name,
          iconPath: asset.iconPath,
          level: level,
          isAsset: true,
          isComponent: asset.isComponent,
          isEnergyAsset: asset.isEnergyAsset,
          assetInCriticalStatus: asset.assetInCriticalStatus,
          children: _buildTreeView(
            locations: [],
            assets: widget.assetTreeView.assets
                .where((a) => a.parentId == asset.id)
                .toList(),
            level: level + 1,
          ),
        ),
      );
    }

    return assetTreeView;
  }

  // build each node (location or asset) in the tree
  Widget _buildTreeNode({
    required String id,
    required String name,
    required String iconPath,
    required int level,
    required bool isAsset,
    bool isComponent = false,
    required bool isEnergyAsset,
    required bool assetInCriticalStatus,
    required List<Widget> children,
  }) {
    bool isExpanded = _expandedState[id] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: level * 20.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: TractianColors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Visibility(
                visible: isEnergyAsset,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    AssetsPaths.boltEnergy,
                  ),
                ),
              ),
              Visibility(
                visible: assetInCriticalStatus,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    AssetsPaths.criticalStatusIcon,
                  ),
                ),
              ),
            ],
          ),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              children.isEmpty
                  ? const SizedBox(width: 24)
                  : Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              const SizedBox(width: 10),
              Image.asset(
                iconPath,
                scale: 4,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _expandedState[id] = !isExpanded;
            });
          },
        ),
        if (isExpanded) ...children,
      ],
    );
  }
}
