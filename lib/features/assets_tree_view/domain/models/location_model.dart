import 'package:assets_challenge/core/utils/assets_path.dart';
import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final String iconPath;
  final int level;
  const LocationModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.iconPath,
    this.level = 0,
  });

  bool get isSubLocation => parentId != null;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      iconPath: AssetsPaths.locationIcon,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        iconPath,
        level,
      ];
}
