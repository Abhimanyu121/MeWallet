import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dbModel.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Transaction,Fav])
abstract class AppDatabase extends FloorDatabase {
  TransactionDao get transactionDao;
  FavDao get favDao;
}