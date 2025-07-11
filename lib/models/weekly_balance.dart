class WeeklyBalance {
  final int? id;
  final int year;
  final int month;
  final int week;
  final double balance;

  WeeklyBalance({
    this.id,
    required this.year,
    required this.month,
    required this.week,
    required this.balance,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'year': year,
        'month': month,
        'week': week,
        'balance': balance,
      };

  factory WeeklyBalance.fromMap(Map<String, dynamic> map) => WeeklyBalance(
        id: map['id'],
        year: map['year'],
        month: map['month'],
        week: map['week'],
        balance: map['balance'],
      );
}
