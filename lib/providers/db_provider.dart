import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  
  //static pendiente
  static dynamic _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_database != null ) return _database;

    _database = await initDB();
    
    return _database;
  }

  Future<Database> initDB() async {

    Directory documentsDirecctory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirecctory.path, 'ScansDB.db');
    print(path);
    print('tabla path creada correctamente');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {

        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT, 
            valor TEXT
          )
        ''');
      }
    );

  }

  /* Future<int> nuevoScanRaw(ScanModel nuevoScan) async {

    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipo ,valor)
      VALUES( $id, '$tipo', '$valor' )
    ''');

    return res;

  } */

  Future<int> nuevoScan(ScanModel nuevoScan) async {

    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());
    print(res);
    //print('tabla scans insertado');
    return res;

  }

  Future<ScanModel?> getScanById(int id ) async {
    final db = await database;
    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;

  }

  Future<List<ScanModel>> getTodosScans( ) async {
    final db = await database;
    final resp = await db.query('Scans');

    List<dynamic> list = resp.isNotEmpty ? resp.map((e) => ScanModel.fromJson(e) ).toList() : [];
    return List.castFrom<dynamic, ScanModel>(list);

  }

  Future<List<ScanModel>> getScansTipo( String tipo ) async {
    final db = await database;
    final resp = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');

    return resp.isNotEmpty ? resp.map((e) => ScanModel.fromJson(e)).toList() : [];

    /* List<dynamic> list = resp.isNotEmpty ? resp.map((e) => ScanModel.fromJson(e) ).toList() : [];
    return List.castFrom<dynamic, ScanModel>(list); */

  }

  Future<int> updateScan(ScanModel nuevoScan)async{
    final db = await database;
    final resp = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?',whereArgs: [nuevoScan.id] );

    return resp;
  }

  Future<int> deleteScan(int id)async{
    final db = await database;
    final resp = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return resp;
  }

  Future<int> deleteAllScan()async{
    final db = await database;
    final resp = await db.rawDelete('''
      DELETE FROM Scans
    ''');

    return resp;
  }


} 