import 'dart:async';
import 'dart:io';

import 'package:a76_working_with_sqlite/model/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  late Database _database;

  // переменные для полей таблицы в базе данных
  String studentsTable = 'Students';
  String columnId = 'id';
  String columnName = 'name';

  Future<Database> get database async {
    if (_database != null) return _database;
    // return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    // переменная 'dir' возвращает тип 'directory'
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'Student.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //  Student
  // Id | Name
  //  0    ..
  //  1    ..
  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $studentsTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT)');
  }

  // READ
  Future<List<Student>> getStudents() async {
    // Database db = await this.database;
    Database db = await database;
    final List<Map<String, dynamic>> studentsMapList =
        await db.query(studentsTable);

    // создаём массив студентов, заполним его данными прочитаными из ДБ
    final List<Student> studentsList = [];
    // studentsMapList.forEach((studentMap) {
    for (var studentMap in studentsMapList) {
      studentsList.add(Student.fromMap(studentMap));
    }

    return studentsList;
  }

  // INSERT метод по добавлению нового студента в БД
  Future<Student> insertStudent(Student student) async {
    // Database db = await this.database;
    Database db = await database;
    student.id = await db.insert(studentsTable, student.toMap());
    return student;
  }

  // UPDATE обновление данных о студенте
  Future<int> updateStudent(Student student) async {
    Database db = await database;
    return await db.update(
      studentsTable,
      student.toMap(),
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }

  // Delete
  Future<int> deleteStudent(int id) async {
    Database db = await database;
    return await db.delete(
      studentsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
