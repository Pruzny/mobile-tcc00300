import 'package:marketplace/model/Advertisement.dart';
import 'package:marketplace/model/User.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _db;
  
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "data.db");
    
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        String sql = """
          CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL
          );
          
          CREATE TABLE advertisement(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            state VARCHAR(2) NOT NULL,
            category VARCHAR NOT NULL,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            telephone VARCHAR(20) NOT NULL,
            description TEXT NOT NULL,
            photo BLOB
            user INTEGER NOT NULL,
            FOREIGN KEY (user) REFERENCES user(id)
          );
            """;
         await db.execute(sql);

      }
    );

    return db;
  }

  Future<int> insertAdvertisement(Advertisement advertisement) async{
    var database = await db;

    int result = await database.insert("advertisement", advertisement.toMap());

    return result;

  }

  getAdvertisements({User? user}) async {
    var database = await db;
    List advertisements;
    if (user == null) {
      advertisements = await database.rawQuery("SELECT * FROM advertisement ORDER BY id ASC");
    } else {
      advertisements = await database.query(
        "advertisement",
        where: "id = ?",
        whereArgs: [user.id]
      );
    }

    return advertisements;
  }
  

  Future<int> deleteAdvertisement(int id) async {
    var database = await db;

    int result = await database.delete(
      "advertisement",
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateAdvertisement(Advertisement advertisement) async {
    var database = await db;

    int result = await database.update(
      "advertisement",
      advertisement.toMap(),
      where: "id = ?",
      whereArgs: [advertisement.id]
    );

    return result;
  }

  Future<int> insertUser(User user) async{
    var database = await db;

    int result = await database.insert("user", user.toMap());

    return result;

  }

  getUsers({String? email, String? name}) async {
    var database = await db;
    List users = [];
    if (email == null && name == null) {
      users = await database.rawQuery("SELECT * FROM user ORDER BY name ASC");
    } else {
      if (email != null) {
        List res = await database.query(
          "user",
          where: "user.email = ?",
          whereArgs: [email]
        );
        users.addAll(res);
      }
      if (name != null) {
        List res = await database.query(
          "user",
          where: "user.name = ?",
          whereArgs: [name]
        );
        users.addAll(res);
      }
    }

    return users;
  }
  
  Future<int> deleteUser(int id) async {
    var database = await db;

    int result = await database.delete(
      "user",
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateUser(User user) async {
    var database = await db;

    int result = await database.update(
      "user",
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id]
    );

    return result;
  }

  getLogin(String username, String password) async {
    var database = await db;
    var user = await database.query(
      "user",
      where: "user.name = ? AND user.password = ?",
      whereArgs: [username, password]
    );

    return user.isNotEmpty ? User.fromMap(user[0]) : null;
  }
}
