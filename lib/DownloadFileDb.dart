import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileDb {

  Future<String> downloadFile(String url, String fileName, String dir) async {
        HttpClient httpClient = new HttpClient();
        File file;
        String filePath = '';
        String myUrl = '';
    
        try {
          myUrl = url+'/'+fileName;
          var request = await httpClient.getUrl(Uri.parse(myUrl));
          var response = await request.close();
          if(response.statusCode == 200) {
            var bytes = await consolidateHttpClientResponseBytes(response);
            filePath = '$dir/$fileName';
            file = File(filePath);
            await file.writeAsBytes(bytes);
          }
          else
            filePath = 'Error code: '+response.statusCode.toString();
        }
        catch(ex){
          filePath = 'Can not fetch url';
        }
    
        return filePath;
      }



      static var httpClient = new HttpClient();
      
Future<File> _downloadFile(String url, String filename) async {
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}
}