import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Product.dart';

class ProductHelper {
  static final _productHelper = ProductHelper.internal();
  static Database? _db;
  static const String tableName = "product";

  ProductHelper.internal();

  factory ProductHelper() {
    return _productHelper;
  }

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  _onCreateDb(Database db, int version) {

    String sql = """
    CREATE TABLE product(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title VARCHAR,
      description TEXT,
      date DATETIME,
      priority INTEGER
    );
    """;

    db.execute(sql);

  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "product.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb
    );

    return db;
  }

  Future<int> insertProduct(Product product) async{
    var database = await db;

    int result = await database.insert(tableName, product.toMap());

    return result;

  }

  getProducts() async {
    var database = await db;
    String sql = "SELECT * FROM $tableName ORDER BY priority ASC";
    List products = await database!.rawQuery(sql);

    return products;
  }
  

  Future<int> deleteProduct(int id) async {
    var database = await db;

    int result = await database!.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateProduct(Product product) async {
    var database = await db;

    int result = await database!.update(
      tableName,
      product.toMap(),
      where: "id = ?",
      whereArgs: [product.id]
    );

    return result;
  }
}