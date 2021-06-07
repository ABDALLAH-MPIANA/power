import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:power/product.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  Product produit;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  DatabaseHelper.internal();
  
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "data_tarif.db");
    
    // Only copy if the database doesn't exist
   // if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){//ligne X
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('data', 'tarif.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
   // }else {
      print("Abdallah");
   // }
    var ourDb = await openDatabase(path);
    return ourDb;
  }

deleteAll() async {
    //_db.rawDelete('Delete * from Product');
    await _db.execute('Delete from Product');
  }



}