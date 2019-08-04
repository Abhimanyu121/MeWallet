import 'package:floor/floor.dart';
@entity
class Transaction{
  @primaryKey
  final int id;
  final String phoneNo;
  final String value;
  Transaction(this.id, this.phoneNo,this.value);
}
@entity
class Fav{
  @primaryKey
  final String phoneNo;
  Fav(this.phoneNo);
}
@dao
abstract class TransactionDao{
  @Query('SELECT * FROM Transaction')
  Future<List<Transaction>> findAllTransaction();
  @insert
  Future<int> insertTransaction(Transaction transaction);
}
@dao
abstract class FavDao{
  @Query('SELECT * FROM Fav')
  Future<List<Fav>> findAllPersons();
  @insert
  Future<int> insertFav(Fav fav);
}