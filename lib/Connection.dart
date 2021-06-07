import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';
//import 'package:path_provider/path_provider.dart';

class Connection extends StatelessWidget{

final imgUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";


@override
Widget build(BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height *0.6,
    width: MediaQuery.of(context).size.width*0.8,
    child: Center(),
  );

}

/*check2()async{
  bool result = await InternetConnectionChecker().hasConnection;
if(result == true) {
  print('YAY! Free cute dog pics!');
} else {
  print('No internet :( Reason:');
  print(InternetConnectionChecker().lastTryResults);
}
}*/

   Future <bool> checkInternet() async{
  try{
     final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         print('connected');
         
        return Future<bool>.value(true);
      }else {
        return Future<bool>.value(false);
      }
  } on SocketException catch (_) {
      print('not connected');
      return Future<bool>.value(false);
    }
}

  checkAndDownload(Dio dio,String url,String savePath)async{
    
    try {
      final result = await InternetAddress.lookup('https://google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        

        // File
        Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

        return true;
      }
      } on SocketException catch (_) {
      print('not connected');
      return false;
    }
}





void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

}





























































































































/**
 *   Future downloadFile(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }
 */