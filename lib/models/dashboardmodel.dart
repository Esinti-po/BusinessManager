class DashboardModel {
  final double todaySales;
  final double todayExpenses;
  final double todayIncome;
  final double monthlyIncome;
  final List<Map<String, dynamic>> lowStockNotifications;

  DashboardModel({
    required this.todaySales,
    required this.todayExpenses,
    required this.todayIncome,
    required this.monthlyIncome,
    required this.lowStockNotifications,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      todaySales: json['today_sales'],
      todayExpenses: json['today_expenses'],
      todayIncome: json['today_income'],
      monthlyIncome: json['monthly_income'],
      lowStockNotifications: json['low_stock_notifications'],
    );
  }
}
