import 'package:equatable/equatable.dart';

class TagModel extends Equatable {
  const TagModel({required this.id, required this.name, this.slug});

  final int id;
  final String name;
  final String? slug;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, if (slug != null) 'slug': slug};

  @override
  List<Object?> get props => [id, name];
}

class BrandModel extends Equatable {
  const BrandModel({required this.id, required this.name, this.slug});

  final int id;
  final String name;
  final String? slug;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, if (slug != null) 'slug': slug};

  @override
  List<Object?> get props => [id, name];
}

class UnitModel extends Equatable {
  const UnitModel({required this.id, required this.shortName, this.longName});

  final int id;
  final String shortName;
  final String? longName;

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        id: json['id'] as int,
        shortName: json['short_name'] as String? ?? '',
        longName: json['long_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'short_name': shortName,
        if (longName != null) 'long_name': longName,
      };

  @override
  List<Object?> get props => [id, shortName];
}

class CountryModel extends Equatable {
  const CountryModel({required this.id, required this.name, this.code});

  final int id;
  final String name;
  final String? code;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        code: json['code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (code != null) 'code': code,
      };

  @override
  List<Object?> get props => [id, name];
}

class VehicleModel extends Equatable {
  const VehicleModel({
    required this.id,
    required this.name,
    this.plateNumber,
    this.notes,
    this.isActive = true,
  });

  final int id;
  final String name;
  final String? plateNumber;
  final String? notes;
  final bool isActive;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        plateNumber: json['plate_number'] as String?,
        notes: json['notes'] as String?,
        isActive: json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (plateNumber != null) 'plate_number': plateNumber,
        if (notes != null) 'notes': notes,
        'is_active': isActive,
      };

  @override
  List<Object?> get props => [id, name];
}
