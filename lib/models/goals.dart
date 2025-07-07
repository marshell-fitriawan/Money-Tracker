class Goal {
  int? id;
  String title;
  String desc;
  double target;

  Goal({
    this.id,
    required this.title,
    required this.desc,
    required this.target,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'target': target,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      target: map['target'] is int
          ? (map['target'] as int).toDouble()
          : map['target'],
    );
  }
}
