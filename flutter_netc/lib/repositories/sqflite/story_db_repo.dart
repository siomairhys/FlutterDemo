import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/sqflite_database_service.dart';
import '../../models/story_model.dart';

class StoryDB {
  final tableName = 'story';

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Future<void> creatTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL, 
      "title" TEXT,
      "responsible" TEXT,
      "dateTime" DATETIME,
      "priority" TEXT,
      "severity" TEXT,
      "itPhase" TEXT,
      "imagePaths" TEXT, 
      PRIMARY KEY ("id" AUTOINCREMENT));""");
  }

  Future<int> create({required StoryModel story}) async {
    final database = await DatabaseService().database;
    final finalStory = story.toMap();
    print('##################create');
    print(finalStory.toString());
    return await database.insert(tableName, story.toMap());

    // return await database.rawInsert(
    //   '''INSERT INTO $tableName (title, responsible, dateTime, priority, severity, itPhase, imagePath) VALUES (?,?)''',
    //   [
    //     story.title,
    //     story.responsible,
    //     story.dateTime,
    //     story.priority,
    //     story.severity,
    //     story.itPhase,
    //     story.imagePath,
    //   ],
    // );
  }

  Future<List<StoryModel>> fetchAll() async {
    final database = await DatabaseService().database;
    final stories = await database.query('$tableName');
    print('##################fetchAll');
    print(stories);
    // final stories = await database.rawQuery(
    //   '''SELECT * from $tableName ORDER BY id''',
    // );
    return stories
        .map((story) => StoryModel.fromSqfliteDatabase(story))
        .toList();
  }

  Future<StoryModel> fetchById(int id) async {
    final database = await DatabaseService().database;

    final story = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    // final story = await database.rawQuery(
    //   '''SELECT * from $tableName WHERE id = ?''',
    //   [id],
    // );
    return StoryModel.fromSqfliteDatabase(story.first);
  }

  Future<int> update({required int id, StoryModel? story}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (story != null) 'title': story.title,
        'responsible': story?.responsible ?? '',
        'dateTime': dateFormat.format(story?.dateTime as DateTime),
        'priority': story?.priority ?? 'Medium',
        'severity': story?.severity ?? 'Medium',
        'itPhase': story?.itPhase ?? 'Analysis',
        'imagePaths': jsonEncode(
          story?.imagePaths,
        ), // Convert List<String> to JSON String
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
    // await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}
