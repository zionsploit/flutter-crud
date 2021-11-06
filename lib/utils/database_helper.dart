
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_crud/models/employee.dart';

class DatabaseHelper{
  static const _databaseName = 'EmployeeData.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path,_databaseName);
    return await openDatabase(dbPath, version:_databaseVersion, onCreate:_onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ${Employee.tblEmployee}(
        ${Employee.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Employee.colName} TEXT NOT NULL,
        ${Employee.colAge} TEXT NOT NULL,
        ${Employee.colEmail} TEXT NOT NULL,
        ${Employee.colAddress} TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertEmployee(Employee employee) async {
    Database db = await database;
    return await db.insert(Employee.tblEmployee, employee.toMap());
  }
  Future<int> updateEmployee(Employee employee) async {
    Database db = await database;
    return await db.update(Employee.tblEmployee, employee.toMap(), where: '${Employee.colId}=?', whereArgs: [employee.id]);
  }

  Future<int> deleteEmployee(int id) async {
    Database db = await database;
    return await db.delete(Employee.tblEmployee, where: '${Employee.colId}=?', whereArgs: [id]);
  }

  Future<List<Employee>> fetchEmployee() async{
    Database db = await database;
    List<Map> employees = await db.query(Employee.tblEmployee);
    return employees.length == 0 ? [] : employees.map((e) => Employee.fromMap(e)).toList();
  }
}