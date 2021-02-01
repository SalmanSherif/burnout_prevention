import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


// database table and column names
final String tableEvents = 'events';
final String columnId = '_id';
final String columnEventType = 'event_type';
final String columnTaskDesc = 'task_description';
final String columnTaskCreated = 'task_created';
final String columnStartDate = 'task_start';
final String columnEndDate = 'task_end';
final String columnTaskDiff = 'task_difficulty';
final String columnSubTasks = 'sub_tasks';
final String columnTaskDone = 'task_done';
final String columnTaskElapsed = 'task_elapsed';

//columnEventType
//columnTaskDesc
//columnTaskCreated
//columnStartDate
//columnEndDate
//columnTaskDiff
//columnSubTasks
//columnTaskDone
//columnTaskElapsed

class CustomEvent{

  int _id;
  String _eventType;                   // Event Type
  String _taskDescription;             // User Description of Task
  DateTime _taskCreated;               // Creation Date for Task
  double _taskDifficulty;                 // Int 0 to 5 rep User Task Difficulty
  String _subEvents;       // Sub Steadi Events
  bool _done;                          // Successful Completion Bool
  bool _taskElapsed;                   // Time Elapsed, Task Failed

  DateTime _defMaxTime = DateTime(2099,1,1);
  DateTime _defMinTime = DateTime(2019,1,1);

  DateTime _selectedStartTime;
  String _formattedStartDate;
  DateTime _selectedEndTime;
  String _formattedEndDate;

  int get id => _id;
  String get eventType => _eventType;
  String get taskDescription => _taskDescription;
  DateTime get taskCreated => _taskCreated;
  double get taskDifficulty => _taskDifficulty;
  String get subEvents => _subEvents;
  bool get done => _done;
  bool get taskElapsed => _taskElapsed;
  DateTime get startTime => _selectedStartTime;
  DateTime get endTime => _selectedEndTime;
  String get endDate => _formattedEndDate;

  CustomEvent(int id, String eventType, String taskDescription, DateTime taskCreated,
      double taskDifficulty, String subEvents, bool done, bool taskElapsed,
      DateTime selectedStartTime, DateTime selectedEndTime
      ){
    this._id = id;
    this._eventType = eventType;
    this._taskDescription = taskDescription;
    this._taskCreated = taskCreated;
    this._taskDifficulty = taskDifficulty;
    this._subEvents = subEvents;
    this._done = done;
    this._taskElapsed = taskElapsed;
    this._selectedStartTime = selectedStartTime;
    this._selectedEndTime = selectedEndTime;
  }

  String startDate(){
    return DateFormat('EEE, MMM d, ''HH:mm').format(_selectedStartTime);
  }

  CustomEvent.fromMap(Map<String, dynamic> map){
    _id = map[columnId];
    _eventType = map[columnEventType];
    _taskDescription = map[columnTaskDesc];
    _taskCreated = map[columnTaskCreated];
    _taskDifficulty = map[columnTaskDiff];
    _subEvents = map[columnSubTasks];
    _done = map[columnTaskDone];
    _taskElapsed = map[columnTaskElapsed];
    _selectedStartTime = map[columnStartDate];
    _selectedEndTime = map[columnEndDate];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnId: _id,
      columnEventType: _eventType,
      columnTaskDesc: _taskDescription,
      columnTaskCreated: _taskCreated,
      columnStartDate: _selectedStartTime,
      columnEndDate: _selectedEndTime,
      columnTaskDiff: _taskDifficulty,
      columnSubTasks: _subEvents,
      columnTaskDone: _done,
      columnTaskElapsed: _taskElapsed,
    };
  }
}

// database table and column names
//final String tableWords = 'words';
//final String columnId = '_id';
//final String columnWord = 'word';
//final String columnFrequency = 'frequency';
//
//// data model class
//class Word {
//
//  int id;
//  String word;
//  int frequency;
//
//  Word();
//
//  // convenience constructor to create a Word object
//  Word.fromMap(Map<String, dynamic> map) {
//    id = map[columnId];
//    word = map[columnWord];
//    frequency = map[columnFrequency];
//  }
//
//  // convenience method to create a Map from this Word object
//  Map<String, dynamic> toMap() {
//    var map = <String, dynamic>{
//      columnWord: word,
//      columnFrequency: frequency
//    };
//    if (id != null) {
//      map[columnId] = id;
//    }
//    return map;
//  }
//}
// singleton class to manage the database

class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableEvents (
                $columnId INTEGER PRIMARY KEY,
                $columnEventType TEXT,
                $columnTaskDesc TEXT,
                $columnTaskCreated DATE,
                $columnStartDate DATE,
                $columnEndDate DATE,
                $columnTaskDiff INTEGER,
                $columnSubTasks TEXT,
                $columnTaskDone INTEGER DEFAULT 0,
                $columnTaskElapsed INTEGER DEFAULT 0
              )
              ''');
  }

  // Database helper methods:
  Future<int> insert(CustomEvent event) async {
    Database db = await database;
    int id = await db.insert(tableEvents, event.toMap());
    return id;
  }

  Future<CustomEvent> queryEvent(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableEvents,
        columns: [columnId],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CustomEvent.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableEvents);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableEvents'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tableEvents, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableEvents, where: '$columnId = ?', whereArgs: [id]);
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}