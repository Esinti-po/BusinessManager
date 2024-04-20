class ExpenseModel {
  final String name;
  int price;
  String date;

  ExpenseModel({required this.name, required this.price, required this.date});
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
        name: json['name'], price: json['price'], date: json['created_at']);
  }
}
