import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// import 'Product.dart';

// https://www.tutorialspoint.com/flutter/flutter_database_concepts.htm
//    runApp(MyApp(products: SQLiteDbProvider.db.getAllProducts()));

class dbSQLiteProvider {
  dbSQLiteProvider._();
  static final dbSQLiteProvider db = dbSQLiteProvider._();
  static Database? _database;

  static String database_name = "database.db" ;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    if (_database!.isOpen) {
      await updateDB(_database!);
    }
    return _database!;
  }

  copyDB() async {
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, database_name);

    // String path = join(documentsDirectory.path,     DBAssistanceClass.databaseName);
    print('The DB path is: ' + path);

// Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      try {
        print('Copying DB...');
        // Load database from asset and copy
        ByteData data = await rootBundle.load(join('assets/db/', database_name));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        // Save copied asset to documents
        await File(path).writeAsBytes(bytes);
      } catch (error) {
        print(error);
      }
    }
  }

  initDB() async {
    await copyDB();

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, database_name);
    return await openDatabase(
      path, version: 6,
      onOpen: (db) async {
        // await updateDB(_database);
      },
      onCreate: (Database db, int version) async {},
      onUpgrade: _onUpgrade,
    );
  }

// UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      upgrade(db);
    }
  }

  updateDB(Database db) async {

    scripts(db);

    var prefs = await SharedPreferences.getInstance();


    String? _updated = prefs.getString("db_ver");
    if (_updated == null) {

      prefs.setString("db_ver", "1");
    }


  }

  void upgrade(Database db) {
    // db.execute("ALTER TABLE in");
     
  }

  void scripts(Database db) {
    // db.execute( "CREATE TABLE IF NOT EXISTS  RecordSleep ( row_id INTEGER PRIMARY KEY AUTOINCREMENT, hours INTEGER  NOT NULL, dt TIMESTAMP NOT NULL )");
  }

}
