import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// import 'Product.dart';

// https://www.tutorialspoint.com/flutter/flutter_database_concepts.htm
//    runApp(MyApp(products: SQLiteDbProvider.db.getAllProducts()));

class dbSQLiteProvider_old {
  dbSQLiteProvider_old._();
  static final dbSQLiteProvider_old db = dbSQLiteProvider_old._();
  static Database? _database;

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
    String path = join(documentsDirectory.path, "db.db");

    // String path = join(documentsDirectory.path,     DBAssistanceClass.databaseName);
    print('The DB path is: ' + path);

// Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      try {
        print('Copying DB...');
        // Load database from asset and copy
        ByteData data = await rootBundle.load(join('res/db/', "db.db"));
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
    String path = join(documentsDirectory.path, "db.db");
    return await openDatabase(
      path, version: 1,
      onOpen: (db) async {
        // await updateDB(_database);
      },
      onCreate: (Database db, int version) async {},
      // onUpgrade: _onUpgrade,
    );
  }

// UPGRADE DATABASE TABLES
//   void _onUpgrade(Database db, int oldVersion, int newVersion) {
//     if (oldVersion < newVersion) {
//       updateDB(db);
//     }
//   }

  void scripts(Database db) {
    db.execute(
        "CREATE TABLE IF NOT EXISTS  weight ( row_id INTEGER PRIMARY KEY AUTOINCREMENT, weight_g INTEGER  NOT NULL, dt TIMESTAMP NOT NULL )");
    db.execute(
        "CREATE TABLE IF NOT EXISTS  water ( row_id INTEGER PRIMARY KEY AUTOINCREMENT, intake DOUBLE  NOT NULL, dt TIMESTAMP NOT NULL )");

    db.execute("ALTER TABLE usinfo ADD COLUMN userid VARCHAR;");
    db.execute("ALTER TABLE usinfo ADD COLUMN username VARCHAR;");
    db.execute("ALTER TABLE usinfo ADD COLUMN name VARCHAR;");
    db.execute("ALTER TABLE usinfo ADD COLUMN buy_id VARCHAR;");
    db.execute("ALTER TABLE usinfo ADD COLUMN wightToLoss DOUBLE;");
    db.execute("ALTER TABLE usinfo ADD COLUMN neck DOUBLE;");
    db.execute("ALTER TABLE usinfo ADD COLUMN waist DOUBLE;");
    db.execute("ALTER TABLE usinfo ADD COLUMN hip DOUBLE;");

    db.execute("ALTER TABLE usrCal ADD COLUMN itemname VARCHAR;");

    db.execute(
        "CREATE TABLE IF NOT EXISTS  cat ( ID INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR , appKey VARCHAR  )");
    db.execute(
        "CREATE TABLE IF NOT EXISTS  items ( ID INTEGER PRIMARY KEY AUTOINCREMENT ,cat_id INTEGER,cat_title VARCHAR, title VARCHAR , weight_g INTEGER ,calories INTEGER , qty  INTEGER , id_app_source  INTEGER , photo_app_source VARCHAR  )");

    db.execute(
        "CREATE TABLE IF NOT EXISTS  app_ver ( id INTEGER PRIMARY KEY AUTOINCREMENT , name  VARCHAR )");

    scripts_insert(db);
  }

  void scripts_insert(Database db) {
    var INSERT_cat_fav = '''
   INSERT INTO cat(title,appKey)
   SELECT 'Favorite' , 'fav'
   WHERE NOT EXISTS(SELECT 1 FROM cat WHERE appKey = 'fav');
   ''';
    db.execute(INSERT_cat_fav);

    var INSERT_cat_breakfast = '''
   INSERT INTO cat(title,appKey)
   SELECT 'Breakfast' , 'breakfast'
   WHERE NOT EXISTS(SELECT 1 FROM cat WHERE appKey = 'breakfast');
   ''';
    db.execute(INSERT_cat_breakfast);

    var INSERT_cat_lunch = '''
   INSERT INTO cat(title,appKey)
   SELECT 'Lunch' , 'lunch'
   WHERE NOT EXISTS(SELECT 1 FROM cat WHERE appKey = 'lunch');
   ''';
    db.execute(INSERT_cat_lunch);

    var INSERT_cat_dinner = '''
   INSERT INTO cat(title,appKey)
   SELECT 'Dinner' , 'dinner'
   WHERE NOT EXISTS(SELECT 1 FROM cat WHERE appKey = 'dinner');
   ''';
    db.execute(INSERT_cat_dinner);

    var INSERT_cat_snacks = '''
   INSERT INTO cat(title,appKey)
   SELECT 'Snacks' , 'snacks'
   WHERE NOT EXISTS(SELECT 1 FROM cat WHERE appKey = 'snacks');
   ''';
    db.execute(INSERT_cat_snacks);

    var INSERT_app_ver = '''
   INSERT INTO app_ver(name)
   SELECT  '1.0'
   WHERE NOT EXISTS(SELECT 1 FROM app_ver WHERE name = '1.0');
   ''';
    db.execute(INSERT_app_ver);
  }

  updateDB(Database db) async {
    var prefs = await SharedPreferences.getInstance();

    // SharedPreferences.getInstance().then((prefs) {

    String? _updated = prefs.getString("db_ver");
    if (_updated == null) {
      scripts(db);

      prefs.setString("db_ver", "1");
    }

    // });
  }

// ========================================================================
  // initDB() async {
  //   Directory documentsDirectory = await
  //   getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, "ProductDB.db");
  //   return await openDatabase(
  //       path, version: 1,
  //       onOpen: (db) {},
  //       onCreate: (Database db, int version) async {
  //         await db.execute(
  //             "CREATE TABLE Product ("
  //                 "id INTEGER PRIMARY KEY,"
  //                 "name TEXT,"
  //                 "description TEXT,"
  //                 "price INTEGER,"
  //                 "image TEXT"")"
  //         );
  //         await db.execute(
  //             "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
  //             values (?, ?, ?, ?, ?)",
  //         [1, "iPhone", "iPhone is the stylist phone ever", 1000, "iphone.png"]
  //         );
  //         await db.execute(
  //         "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
  //         values (?, ?, ?, ?, ?)",
  //         [2, "Pixel", "Pixel is the most feature phone ever", 800, "pixel.png"]
  //         );
  //         await db.execute(
  //         "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
  //         values (?, ?, ?, ?, ?)",
  //         [3, "Laptop", "Laptop is most productive development tool", 2000, "laptop.png"]
  //         );
  //         await db.execute(
  //         "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
  //         values (?, ?, ?, ?, ?)",
  //         [4, "Tablet", "Laptop is most productive development tool", 1500, "tablet.png"]
  //         );
  //         await db.execute(
  //         "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
  //         values (?, ?, ?, ?, ?)",
  //         [5, "Pendrive", "Pendrive is useful storage medium", 100, "pendrive.png"]
  //         );
  //         await db.execute(
  //         "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
  //         values (?, ?, ?, ?, ?)",
  //         [6, "Floppy Drive", "Floppy drive is useful rescue storage medium", 20, "floppy.png"]
  //         );
  //       }
  //   );
  // }
  // Future<List<Product>> getAllProducts() async {
  //   final db = await database;
  //   List<Map> results = await db.query(
  //       "Product", columns: Product.columns, orderBy: "id ASC"
  //   );
  //   List<Product> products = new List();
  //   results.forEach((result) {
  //     Product product = Product.fromMap(result);
  //     products.add(product);
  //   });
  //   return products;
  // }
  // Future<Product> getProductById(int id) async {
  //   final db = await database;
  //   var result = await db.query("Product", where: "id = ", whereArgs: [id]);
  //   return result.isNotEmpty ? Product.fromMap(result.first) : Null;
  // }
  // insert(Product product) async {
  //   final db = await database;
  //   var maxIdResult = await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Product");
  //   var id = maxIdResult.first["last_inserted_id"];
  //   var result = await db.rawInsert(
  //       "INSERT Into Product (id, name, description, price, image)"
  //           " VALUES (?, ?, ?, ?, ?)",
  //       [id, product.name, product.description, product.price, product.image]
  //   );
  //   return result;
  // }
  // update(Product product) async {
  //   final db = await database;
  //   var result = await db.update(
  //       "Product", product.toMap(), where: "id = ?", whereArgs: [product.id]
  //   );
  //   return result;
  // }
  // delete(int id) async {
  //   final db = await database;
  //   db.delete("Product", where: "id = ?", whereArgs: [id]);
  // }
}
