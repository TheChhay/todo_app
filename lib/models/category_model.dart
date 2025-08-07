

class CategoryModel {
  int? id;
  final String name;
  String? color;

  CategoryModel({
    this.id,
    required this.name,
    this.color, // make optional
  }); // set default


  /// JSON Factory
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String?, // allow null, use default
    );
  }

  /// JSON to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

}
