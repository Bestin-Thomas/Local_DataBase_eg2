import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBStudentManager {
  late Database _datebase;

  Future openDB() async {
    _datebase = await openDatabase(join(await getDatabasesPath(), "student.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,course TEXT)");
    }
    );
  }//FOR CREATE DATABASE AND TABLE


  Future<int> insertStudent(Student student) async {
    await openDB();
    return await _datebase.insert('student', student.toMap());
  }//FOR INSERT DATA INTO THE DATABASE




  Future<List<Student>> getStudentList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _datebase.query('student');
    return List.generate(maps.length, (index) {
      return Student(id: maps[index]['id'], name: maps[index]['name'], course: maps[index]['course']);
    });
  }//FOR GET DATA FROM THE DATABASE


  Future<int> updateStudent(Student student) async {
    await openDB();
    return await _datebase.update('student', student.toMap(), where: 'id=?', whereArgs: [student.id]);
  }// UPADATE THE DATABASE

  Future<void> deleteStudent(int? id) async {
    await openDB();
    await _datebase.delete("student", where: "id = ? ", whereArgs: [id]);
  }//TO REMOVE A DATA FROM A TABLE OR DATABASE
}

class Student {
  int? id;
  String name;
  String course;
  Student({ this.id,required this.name, required this.course});
  Map<String, dynamic> toMap() {
    return {'name': name, 'course': course};
  }
}
