class Products {
  final String id;
  final String name;
  final String category;
  final double old_price;
  final double new_price;
  final String image;
  final String description;

  Products(this.id, {
    required this.name,
    required this.category,
    required this.old_price,
    required this.new_price,
    required this.image,
    required this.description,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
        json['id'] ?? '',
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        old_price: json['old_price']?.toDouble() ?? 0.0,
        new_price: json['new_price']?.toDouble() ?? 0.0,
        image: json['image'] ?? '',
        description: json['description'] ?? '');
  }
}
