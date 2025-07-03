import '../repositories/sqflite/story_db_repo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();
    print("##################database");
    print(_database);
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'sample.db';
    final path = await getDatabasesPath();
    print("##################fullPath");
    print(join(path, name));
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    print("##################_initialize > fullPath :$path");
    print("##################_initialize");
    print(database);
    return database;
  }

  Future<void> create(Database database, int version) async {
    await StoryDB().creatTable(database);
    print("##################create");
  }
}
