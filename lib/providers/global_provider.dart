import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
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
  ScrollController uploadPageScrollController = ScrollController();
  void setPickedFile(PlatformFile file) async{
    pickedFile = file;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 10));
    uploadPageScrollController
      .animateTo(
        uploadPageScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn
    );
  }

  void removeFile() async{
    uploadPageScrollController
            .animateTo(
              uploadPageScrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn
        );
    await Future.delayed(const Duration(milliseconds: 200));
    pickedFile = null;
    notifyListeners();
  }

  int? fireResponse;
  void setFireResponse(int res){
    fireResponse = res;
    notifyListeners();
  }
  void removeFireResponse(){
    fireResponse = null;
    notifyListeners();
  }

  bool detectionStarted = false;

  startDetection(){
    detectionStarted = true;
    notifyListeners();
  }

  endDetection(){
    detectionStarted = false;
    notifyListeners();
  }


  //MAP PAGE
  LatLng? pinPosition;
  void changeMarkerPosition(LatLng position, AnimatedMapController animatedMapController){
    // pinPosition = mapController.camera.center;
    pinPosition = position;
    double mapZoom = animatedMapController.mapController.camera.zoom;
    if(animatedMapController.mapController.camera.zoom < 6){
      mapZoom = 6;
    }
    animatedMapController.animateTo(dest: position, zoom: mapZoom);
    // mapController.move(position, mapController.camera.zoom);

    notifyListeners();
  }

  void removeMarkerPosition(AnimatedMapController animatedMapController){
    pinPosition = null;
    animatedMapController.animateTo(dest: const LatLng(23.2032, 77.0844), zoom: 4.5);
    animatedMapController.animatedRotateReset();
    notifyListeners();
  }

  // messaging services
  bool messagingServiceEnabled = false;
  void enableMessagingService(){
    if(!messagingServiceEnabled){
      messagingServiceEnabled = true;
      notifyListeners();
    }
  }
  void disableMessagingService(){
    if(messagingServiceEnabled){
      messagingServiceEnabled = false;
      notifyListeners();
    }
  }
}