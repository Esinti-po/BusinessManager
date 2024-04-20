class UserStockModel {
  final String name;
  final String description;
  int quantity;
  int sellingPrice;

  UserStockModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.sellingPrice,
  });

  factory UserStockModel.fromJson(Map<String, dynamic> json) {
    return UserStockModel(
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      sellingPrice: json['s_price'],
    );
  }
}
