import 'package:softtask/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class LocalDatabase {
  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, role TEXT)',
        );
      },
      version: 1,
    );
  }
  Future<void> insertUser({required String name, required String email, required String role}) async {
    await _database.insert(
      'users',
      UserData(name: name, email: email, role: role).toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserData>> getUser(String email) async {
    final List<Map<String, dynamic>> maps = await _database.query('users', where: "email = ?", whereArgs: [email]);
    return List.generate(maps.length, (i) {
      return UserData(
        name: maps[i]['name'] as String,
        email: maps[i]['email'] as String,
        role: maps[i]['role'] as String,
      );
    });
  }

  Future<List<UserData>> getUsers() async {
    final List<Map<String, dynamic>> maps = await _database.query('users');
    return List.generate(maps.length, (i) {
      return UserData(
        name: maps[i]['name'] as String,
        email: maps[i]['email'] as String,
        role: maps[i]['role'] as String,
      );
    });
  }
}
