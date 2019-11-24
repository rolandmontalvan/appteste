import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:todo/model/todo_model.dart';
import 'package:todo/model/task_model.dart';

class DBProvider {
  static Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  var todos = [
    Todo(
      "Carlos Silva",
      parent: '1',
    ),
    Todo(
      "Sebastião Cabral",
      parent: '1',
    ),
    Todo(
      "Rota 01",
      parent: '2',
    ),
    Todo(
      "Rota 02",
      parent: '2',
    ),
    Todo(
      "Rota 03",
      parent: '2',
    ),
    Todo(
      "Herminio Solto",
      parent: '3',
    ),
    Todo(
      "José Francisco",
      parent: '3',
    ),
    Todo(
      "Hugo Neto",
      parent: '3',
    ),
    Todo(
      "Escola Sebastião Rabelo",
      parent: '4',
    ),
    Todo(
      "Colégio Redenção",
      parent: '4',
    ),
    Todo(
      "Lucio Alves",
      parent: '5',
    ),
    Todo(
      "Ivan Dantas",
      parent: '5',
    ),
    Todo(
      "Colégio Redenção",
      parent: '6',
    ),
    Todo(
      "Lucio Alves",
      parent: '6',
    ),
    Todo(
      "Escola Sebastião Rabelo",
      parent: '6',
    ),
    Todo(
      "Colégio Redenção",
      parent: '7',
    ),
    Todo(
      "Lucio Alves",
      parent: '7',
    ),
  ];

  var tasks = [
    Task('Agente de Campo',
        id: '1', color: Colors.black.value, codePoint: Icons.people.codePoint),
    Task('Rota',
        id: '2',
        color: Colors.black.value,
        codePoint: Icons.track_changes.codePoint),
    Task('Aluno',
        id: '3',
        color: Colors.black12.value,
        codePoint: Icons.perm_identity.codePoint),
    Task('Escola',
        id: '4',
        color: Colors.black26.value,
        codePoint: Icons.business.codePoint),
    Task('Motorista',
        id: '5',
        color: Colors.black38.value,
        codePoint: Icons.account_box.codePoint),
    Task('Veículo',
        id: '6',
        color: Colors.black45.value,
        codePoint: Icons.directions_car.codePoint),
    Task('Fiscal de Campo',
        id: '7',
        color: Colors.black54.value,
        codePoint: Icons.person_outline.codePoint)
  ];

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  get _dbPath async {
    String documentsDirectory = await _localPath;
    return p.join(documentsDirectory, "Todo.db");
  }

  Future<bool> dbExists() async {
    return File(await _dbPath).exists();
  }

  initDB() async {
    String path = await _dbPath;
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print("DBProvider:: onCreate()");
      await db.execute("CREATE TABLE Task ("
          "id TEXT PRIMARY KEY,"
          "name TEXT,"
          "color INTEGER,"
          "code_point INTEGER"
          ")");
      await db.execute("CREATE TABLE Todo ("
          "id TEXT PRIMARY KEY,"
          "name TEXT,"
          "parent TEXT,"
          "completed INTEGER NOT NULL DEFAULT 0"
          ")");
    });
  }

  insertBulkTask(List<Task> tasks) async {
    final db = await database;
    tasks.forEach((it) async {
      var res = await db.insert("Task", it.toJson());
      print("Task ${it.id} = $res");
    });
  }

  insertBulkTodo(List<Todo> todos) async {
    final db = await database;
    todos.forEach((it) async {
      var res = await db.insert("Todo", it.toJson());
      print("Todo ${it.id} = $res");
    });
  }

  Future<List<Task>> getAllTask() async {
    final db = await database;
    var result = await db.query('Task');
    return result.map((it) => Task.fromJson(it)).toList();
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    var result = await db.query('Todo');
    return result.map((it) => Todo.fromJson(it)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return db
        .update('Todo', todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> removeTodo(Todo todo) async {
    final db = await database;
    return db.delete('Todo', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return db.insert('Todo', todo.toJson());
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('Task', task.toJson());
  }

  Future<void> removeTask(Task task) async {
    final db = await database;
    return db.transaction<void>((txn) async {
      await txn.delete('Todo', where: 'parent = ?', whereArgs: [task.id]);
      await txn.delete('Task', where: 'id = ?', whereArgs: [task.id]);
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db
        .update('Task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  closeDB() {
    if (_database != null) {
      _database.close();
    }
  }
}
