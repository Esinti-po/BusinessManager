class SalesModel {
  final String name;
  int quantity;
  int unitPrice;
  int totalPrice;
  // var todayTotalSales;
  final String modeOfPayment;
  String date;

  SalesModel({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.modeOfPayment,
    required this.date,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      modeOfPayment: json['mode_of_payment'],
      date: json['created_at'],
    );
  }
}
