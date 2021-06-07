import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:power/DataBaseHelper.dart';
import 'package:power/QueryCtr.dart';
import 'package:power/product.dart';
import 'Connection.dart';
import 'dart:io';
import 'package:dio/dio.dart';





void main() {
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {

  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Power'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

QueryCtr _query = new  QueryCtr();
Connection con= new Connection();
Dio dio= Dio();
DatabaseHelper dbh = DatabaseHelper();
bool internet=false;


@override
  void initState() {
  super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_)async{
    try{
     final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         print('connected');
         internet=true;
        _query.getJsonAndInsert();
      }else {
       print('not connected'); 
       internet=false;
      }
  } on SocketException catch (_) {
      print('not connected');
    }

  });
  
   //WidgetsBinding.instance.addPostFrameCallback((_) => _query.getJsonAndInsert());
   
  }


//clic du menuBouton
 handleClick(String value) {
    switch (value) {
      case 'Info App':
      {
        //_aproposApp(context);
      }
        break;
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: new Icon(Icons.search),
                     onPressed: (){
                       showSearch(context: context, 
                       delegate: SearchProduct()
                       );
                     }),

          PopupMenuButton(itemBuilder: (BuildContext context ){
            return[
              const PopupMenuItem(child: Text('Info App'),value: "Info App", ),
             ];
          },
        onSelected: handleClick,
          )
          
        ],
      ),
      body:  FutureBuilder<List>(
        future: getAllProducts(),
        initialData: [],
        builder: (context,snapshot){
        return 
        snapshot.hasData // && getAllProducts() != null
        ? ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, int index){
            return Card(
              color: Colors.blue[100],
              elevation: 2.0,
              shadowColor: Colors.blue[50],
              child: _buildRow(snapshot.data[index]) ,
            );

          },)
          :
          Center(
                    child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(internet==true
                                ?
                                'Update Loading...😉'
                                :'No data found 😭!\nPlease connect to the internet for updates and restart the app',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold 
                                ),
                                textAlign: TextAlign.center,
                                ),
                            Divider(),
                            CircularProgressIndicator()
                            ],
                          ),
                        );
        }
        
        )
      
    );
  }



  Future<List<Product>> getAllProducts() async {
    
    var dbClient = await dbh.db;
    var res = await dbClient.query("product");
    
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() 
                       : null;
    //print(list.isEmpty);
    setState((){
      list=list;
    });
    return list;
    
  }

Widget _buildRow(Product product) {
    return new ListTile(
      onTap: (){
        setState(() {
          showDialog(context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Details"),
              content:Container(
                color: Colors.blue[50],
                height: MediaQuery.of(context).size.height*0.4,
                child:  ListView(
              children: [
                ListTile(
                  title: 
               new Text(product.positiontarifaire ==null
                        ?""
                        :"POSITION TARIFAIRE : "+product.positiontarifaire
               ),
                ),
                ListTile(
                  title: 
               new  Text(product.libelle ==null
                        ?""
                        :"LIBELLE : "+product.libelle),
                ),
                ListTile(
                  title: 
               new  Text(product.date ==null
                        ?""
                        :"DATE : "+product.date) ,
                ),
                ListTile(
                  title:
               new  Text(
                 product.ddi ==null
                        ?""
                        :"DDI : "+product.ddi),
                ),
                 ListTile(
                  title: 
               new  Text(product.tva ==null
                        ?""
                        :product.tva) ,
                )
              ],
            ),),
            actions: [
              new ElevatedButton(onPressed: ()=>Navigator.pop(context),
                                 child: Text("Ok"))
            ],
            );
          },
          );
          
        });
      },
      title: new Text(product.positiontarifaire,),
      subtitle: new Text(product.libelle),
    );
  }



}

class SearchProduct extends SearchDelegate<Product>{
QueryCtr _query = new  QueryCtr();
  @override
  List<Widget> buildActions(BuildContext context) {
   return [
IconButton(icon: Icon(Icons.clear), onPressed: (){
           query="";
})
];
  }

  @override
  Widget buildLeading(BuildContext context) {
     return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          close(context,null);
});
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query.toUpperCase(),style: TextStyle(fontSize: 20,),),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder <List>(
       future: _query.getAllProducts2(),
      initialData: [],
      builder: ( context,snapshot){
  
         final results = snapshot.data.where((P) => P.libelle.startsWith(query.toUpperCase())).toList();
         //final results = snapshot.data.where((Product) => Product.libelle.contains(query)).toList();
         if(results.isEmpty){
           print("null");
         }

        return snapshot.hasData && _query.getAllProducts2() != null
        ? ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index){
            return _buildRowSearch(results[index],context) ;
         },
      ):Center(child: CircularProgressIndicator(),
                        );
      });

  }




  
Widget _buildRowSearch(Product product, BuildContext context) {
    return new ListTile(
      onTap: (){
     //   setState(() {
          showDialog(context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Details"),
              content:Container(
                color: Colors.blue[50],
                height: MediaQuery.of(context).size.height*0.40,
                child:  ListView(
              children: [
                ListTile(
                  title: 
               new Text(product.positiontarifaire ==null
                        ?""
                        :"POSITION TARIFAIRE : "+product.positiontarifaire
               ),
                ),
                ListTile(
                  title: 
               new  Text(product.libelle ==null
                        ?""
                        :"LIBELLE : "+product.libelle),
                ),
                ListTile(
                  title: 
               new  Text(product.date ==null
                        ?""
                        :"DATE : "+product.date) ,
                ),
                ListTile(
                  title:
               new  Text(
                 product.ddi ==null
                        ?""
                        :"DDI : "+product.ddi),
                ),
                 ListTile(
                  title: 
               new  Text(product.tva ==null
                        ?""
                        :"TVA : "+product.tva) ,
                ),
              ],
            )
            ,),
            actions: [
              new ElevatedButton(onPressed: ()=>Navigator.pop(context),
                                 child: Text("Ok"))
            ],
            );
          }
          ,
          );
          
      //  });
      },
      title: new Text(product.positiontarifaire,),
      subtitle: new Text(product.libelle),
    );
  }

}