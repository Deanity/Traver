class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'sortOrder': sortOrder,
      };
}
