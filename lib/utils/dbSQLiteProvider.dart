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

  static String database_name = "fudc_db.db" ;

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
        ByteData data = await rootBundle.load(join('res/db/', database_name));
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
    db.execute("ALTER TABLE usinfo ADD COLUMN period VARCHAR;");
    db.execute("ALTER TABLE usinfo ADD COLUMN period_date VARCHAR;");

    db.execute("ALTER TABLE items ADD COLUMN pro_ml INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN carb_ml INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN fat_ml INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN Blocks_measurement INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN unit_density_gram INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN energy_kilojoules INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN protein_g INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN carbohydrate_g INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN fat_g INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN sugar_g INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN dietary_fiber_g INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN saturated_fat INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN cholesterol_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN calcium_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN iron_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN sodium_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN potassium_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN magnesium_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN phosphorous_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN thiamine_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN riboflavin_mg INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN Neon_niacin_micro INTEGER;");
    db.execute("ALTER TABLE items ADD COLUMN folic_acid_micro INTEGER;");

    db.execute("ALTER TABLE usrCal ADD COLUMN id_app_source INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN cat_id INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN cat_title VARCHAR;");
    db.execute("ALTER TABLE usrCal ADD COLUMN photo VARCHAR;");

    db.execute("ALTER TABLE usrCal ADD COLUMN pro_ml INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN carb_ml INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN fat_ml INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN Blocks_measurement INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN unit_density_gram INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN energy_kilojoules INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN protein_g INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN carbohydrate_g INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN fat_g INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN sugar_g INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN dietary_fiber_g INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN saturated_fat INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN cholesterol_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN calcium_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN iron_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN sodium_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN potassium_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN magnesium_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN phosphorous_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN thiamine_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN riboflavin_mg INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN Neon_niacin_micro INTEGER;");
    db.execute("ALTER TABLE usrCal ADD COLUMN folic_acid_micro INTEGER;");
  }

  void scripts(Database db) {
    db.execute( "CREATE TABLE IF NOT EXISTS  RecordSleep ( row_id INTEGER PRIMARY KEY AUTOINCREMENT, hours INTEGER  NOT NULL, dt TIMESTAMP NOT NULL )");
  }

}
