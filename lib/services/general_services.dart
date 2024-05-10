
// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';
import 'package:fireye/global/constants/constants.dart';
import 'package:fireye/providers/global_provider.dart';
// import 'package:fireye/screens/dashboard/pages/dashboard_page.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Services {
  Future selectFile(GlobalProvider provider) async{
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false
    );
    
    if(result == null) return;
    provider.setPickedFile(result.files.first);


  }

  detectFirePhoto(GlobalProvider provider) async{
    provider.removeFireResponse();
    provider.startDetection();
    var uri = Uri.parse('http://jhankar.in:5005/predict');
    var request = http.MultipartRequest('POST', uri);
    print(provider.pickedFile!.name);
    request
      .files
        .add(
          await http.MultipartFile.fromPath('file', provider.pickedFile!.path.toString())
        );
    var response = await request.send();
    if(response.statusCode == 200){
      print('Sent to Server Successfully with status code 200\nOUTPUT:');
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      print(Constants.fireResponseDecode[int.parse(responseString)]);
      provider.setFireResponse(int.parse(responseString));
      provider.endDetection();
    }
  }

  detectFireVideo(GlobalProvider provider) async{
    provider.removeFireResponse();
    provider.startDetection();
    var uri = Uri.parse('http://jhankar.in:5005/video');
    var request = http.MultipartRequest('POST', uri);
    print(provider.pickedFile!.name);
    request
      .files
        .add(
          await http.MultipartFile.fromPath('file', provider.pickedFile!.path.toString())
        );
    var response = await request.send();
    if(response.statusCode == 200){
      print('Sent to Server Successfully with status code 200\nOUTPUT:');
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      print(Constants.fireResponseDecode[int.parse(responseString)]);
      provider.setFireResponse(int.parse(responseString));
      provider.endDetection();
    }
  }
}