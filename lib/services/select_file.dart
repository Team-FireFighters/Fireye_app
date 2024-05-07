
import 'package:file_picker/file_picker.dart';

class Services {
  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false
    );

    

  }
}