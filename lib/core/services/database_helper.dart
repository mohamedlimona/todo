import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_firebase/models/task.dart';
// import 'package:todo_firebase/models/todo.dart';



class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tasks(timestamp TEXT PRIMARY KEY, title TEXT, description TEXT, time TEXT)");
        await db.execute(
            "CREATE TABLE todo(timestamp TEXT PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");

        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> insertTodo(Task todo) async {
    Database _db = await database();
    await _db.insert('tasks', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          // id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],

      time: taskMap[index]['time'],
        timestamp:taskMap[index]['timestamp'],);
    });
  }





  Future<void> deleteTask(String id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE timestamp = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }
}
