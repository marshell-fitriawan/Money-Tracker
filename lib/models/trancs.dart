class Trancs {
  int? id;
  String title;
  double amount;
  DateTime date;
  bool jenis;
  String? desc; // Tambahkan field deskripsi

  Trancs({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.jenis,
    this.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'jenis': jenis ? 1 : 0,
      'desc': desc,
    };
  }

  factory Trancs.fromMap(Map<String, dynamic> map) {
    return Trancs(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      jenis: map['jenis'] == 1,
      desc: map['desc'],
    );
  }
}
