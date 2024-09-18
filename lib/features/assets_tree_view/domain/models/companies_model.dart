import 'package:equatable/equatable.dart';

class CompaniesModel extends Equatable {
  final String id;
  final String name;
  const CompaniesModel({
    required this.id,
    required this.name,
  });

  factory CompaniesModel.fromJson(Map<String, dynamic> json) {
    return CompaniesModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
