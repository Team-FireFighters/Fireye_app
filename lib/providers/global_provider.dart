import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier{
  int currentPage = 0;
  PageController pageController = PageController(keepPage: true);
  void changeCurrentPage(int page){
    if(page != currentPage) {
      currentPage = page;
      notifyListeners();
      pageController.animateToPage(page, duration: const Duration(milliseconds: 200), curve: Easing.standard);
    }
  } 

  PlatformFile? pickedFile;

}