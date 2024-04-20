class NotificationsModel {
  final String name;
  final String description;
  int quantity;

  NotificationsModel({
    required this.name,
    required this.description,
    required this.quantity,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
    );
  }
}
