// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:fireye/global/constants/constants.dart';
import 'package:fireye/global/constants/phone_numbers.dart';
import 'package:fireye/global/helpers/app_colors.dart';
import 'package:fireye/providers/global_provider.dart';
import 'package:fireye/screens/dashboard/widgets/navbar_buttons.dart';
import 'package:fireye/screens/location/pages/location_page.dart';
import 'package:fireye/screens/upload/pages/upload_page.dart';
import 'package:fireye/services/messaging_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    void switchEmergencyPhoneNumber(GlobalProvider provider){
      showCupertinoModalPopup(
        context: context,
        builder: (context) =>  CupertinoAlertDialog(
          title: Text(
            provider.emergencyContact == PhoneNumbers.personalPhoneNumber0? 
                'Switch To Rishit' : 'Switch To Parth',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(5),
              Text(
                'Switch Emergency Contact?' ,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Gap(5),
              Text(
                'Note: This action will change your emergency contact number.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                provider.emergencyContact == PhoneNumbers.personalPhoneNumber0 ? 
                  provider.switchToRishit() :
                    provider.switchToParth();
                String person = provider.emergencyContact == PhoneNumbers.personalPhoneNumber0 ? 'Parth' : 'Rishit';
                Constants().showSnackBarMessage(
                  context, 
                  customMessage: 'Switched to $person!',
                );
              },
              isDestructiveAction: true,
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.lightBlue
                ),
              ),
            )
          ],
        ),
      );
    }
    void showEmergencyDialog(bool messagingEnabled, String phNo){
      showCupertinoModalPopup(
        context: context,
        builder: (context) =>  CupertinoAlertDialog(
          title: const Text(
            'Emergency',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(5),
              Text(
                'Alert emergency services?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Gap(5),
              Text(
                'Note: This action will alert the local emergency services, unnecessary use of this can lead to legal actions.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                try{
                  launchUrlString("tel://$phNo");
                } catch(e){
                  Constants().showSnackBarMessage(context, customMessage: 'Unable to call ATM',);
                }
                },
              child: Text(
                'Call',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8)
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async{
                try{
                  var enabled =  await Geolocator.isLocationServiceEnabled();
                  print(enabled);
                  if(await Geolocator.isLocationServiceEnabled()){
                    print('location services enabled');
                  } else{
                    print('!!location services not enabled');
                  }
                  if(await Geolocator.checkPermission() == LocationPermission.denied){
                    print('Permission Denied, trying to get permission');
                    await Geolocator.requestPermission();
                  }
                  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                  print(position.latitude);
                  print(position.longitude);

                  // -- MESSAGING SERVICE --
                  messagingEnabled ? 
                    MessagingService().sendAlertMessage(LatLng(position.latitude, position.longitude), phNo) :
                      null;
                    // ignore: use_build_context_synchronously
                    Constants().showSnackBarMessage(context, customMessage: messagingEnabled ? 'Local Emergency Services Alerted' : 'Messaging service is disabled');

                  
                } catch(e){
                  print(e);
                  // ignore: use_build_context_synchronously
                  Constants().showSnackBarMessage(context, customMessage: 'Unable to get Location Permission');
                }
              },
              isDestructiveAction: true,
              child: const Text(
                'Alert Now',
                style: TextStyle(
                  color: AppColors.redAlt
                ),
              ),
            )
          ],
        ),
      );
    }


    return Consumer<GlobalProvider>(
      builder: (context, provider, child) => 
      Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: PageView(
          controller: provider.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            UploadPage(),
            LocationPage()
            ],
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              alignment: Alignment.bottomCenter,
              height: devicePadding.bottom + 45,
              decoration: BoxDecoration(
                color: 
                  provider.currentPage == 0 ?
                    Colors.black.withOpacity(0.1) : 
                      Colors.white.withOpacity(1),
                border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1), width: 0.8))
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  0,
                  15,
                  20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavBarButtons(
                      isActive: provider.currentPage == 0,
                      icon: CupertinoIcons.cloud_upload,
                      onPressed: () => provider.changeCurrentPage(0),
                    ),
                    NavBarButtons(isActive: provider.currentPage == 1, icon: CupertinoIcons.map, onPressed: () => provider.changeCurrentPage(1),),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => showEmergencyDialog(provider.messagingServiceEnabled, provider.emergencyContact),
                        onLongPress: () => switchEmergencyPhoneNumber(provider),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                        child: Ink(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: const Center(
                            child: Text(
                              'Emergency',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

