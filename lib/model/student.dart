class Student {
  // свойства
  int? id;
  late String name;

  // конструктор
  Student(this.id, this.name);

  // метод 'to map'
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  // метод 'from map'
  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
