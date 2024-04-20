class UserModel {
  int userId;
  final String businessName;

  UserModel({
    required this.userId,
    required this.businessName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      businessName: json['business_name'],
    );
  }
}
