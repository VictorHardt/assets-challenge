import 'package:assets_challenge/core/utils/assets_path.dart';
import 'package:equatable/equatable.dart';

class AssetModel extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  final String? locationId;
  final String iconPath;
  const AssetModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    required this.locationId,
    required this.iconPath,
  });

  // If the item has a sensorType, it means it is a component.
  bool get isComponent => sensorType != null;

  // If the item has a sensorType, it means it is a component. If it does not have a location or a parentId, it means he is unliked from any asset or location in the tree.
  bool get isComponentWithoutParent =>
      isComponent && locationId == null && parentId == null;

  // If the item has a sensorType, it means it is a component. If it does have a location or a parentId, it means he has an asset or Location as parent
  bool get isComponentWithParent =>
      isComponent && (locationId != null || parentId != null);

  // If the item has a location and does not have a sensorId, it means he is an asset with a location as parent, from the location collection
  bool get parentIsLocation => locationId != null && sensorId == null;

  // If the item has a parentId and does not have a sensorId, it means he is an asset with another asset as a parent
  bool get parentIsAsset => parentId != null && sensorId == null;

  bool get isEnergyAsset => sensorType == 'energy';

  bool get assetInCriticalStatus => status == 'alert';

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
      gatewayId: json['gatewayId'],
      locationId: json['locationId'],
      iconPath: json['sensorType'] != null
          ? AssetsPaths.componentIcon
          : AssetsPaths.assetIcon,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        iconPath,
      ];
}
