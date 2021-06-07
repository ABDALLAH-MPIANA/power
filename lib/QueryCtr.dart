
import 'package:power/Connection.dart';
import 'package:power/product.dart';
import 'dart:io';
import 'dart:async';
import 'package:power/DataBaseHelper.dart';
import 'dart:convert';
import 'DataBaseHelper.dart';
import 'package:http/http.dart' as http;


class QueryCtr {
DatabaseHelper con = new DatabaseHelper();
Connection internet= Connection();

  Future<List<Product>> getAllProducts2() async {
    
    var dbClient = await con.db;
    var res = await dbClient.query("product");
    
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() 
                       : null;// ici qu'on doit telecharger les données ; verifier l'internet; ecraser le fichier existant
    //print(list.isEmpty);
    
    return list;
    
  }



  getJsonAndInsert()async{
    try{
    final db= await con.db;
    List<Product> listP=[];

    var response = await http.get(Uri.parse('https://dgda-tarif.herokuapp.com/product/api'));

    print("le json en question en Connexion"+json.decode(response.body).toString());

    if(response.statusCode==200 && response != null){
      // var jsonResponse = Product.fromJson(jsonDecode(response.body))  ;
      listP=(json.decode(response.body) as List).map((e) => Product.fromJson(e)).toList();
      
        //con.deleteAll();
        for(int i=0;i<=listP.length;i++){
        var res = await db.insert('Product', listP[i].toMap());
        return res;
                 }
      
      } else {
        print('No connecté \nLe json en cas de non connexion :'+json.decode(response.body).toString());
      }

   } on SocketException catch (_){
     print('non connecté');

    }
 
   }


  
}