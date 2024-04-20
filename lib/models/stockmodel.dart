class StockModel {
  final String name;
  final String description;
  int quantity;
  int buyingPrice;
  int sellingPrice;
  String createdAt;

  StockModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.createdAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
        name: json['name'],
        description: json['description'],
        quantity: json['quantity'],
        buyingPrice: json['b_price'],
        sellingPrice: json['s_price'],
        createdAt: json['created_at']);
  }
}
