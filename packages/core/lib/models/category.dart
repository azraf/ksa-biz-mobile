import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.parentId,
    this.children = const [],
  });

  final int id;
  final String name;
  final String? slug;
  final int? parentId;
  final List<CategoryModel> children;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String?,
        parentId: json['parent_id'] as int?,
        children: (json['children'] as List<dynamic>? ?? [])
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (slug != null) 'slug': slug,
        if (parentId != null) 'parent_id': parentId,
      };

  @override
  List<Object?> get props => [id, name, parentId];
}
