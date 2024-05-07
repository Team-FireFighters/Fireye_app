import 'dart:ui';

import 'package:fireye/global/helpers/app_colors.dart';
import 'package:fireye/providers/global_provider.dart';
import 'package:fireye/screens/dashboard/widgets/navbar_buttons.dart';
import 'package:fireye/screens/location/pages/location_page.dart';
import 'package:fireye/screens/upload/pages/upload_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    void showAlertSentMessage(){
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        backgroundColor: Colors.transparent,
        closeIconColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating, 
        dismissDirection: DismissDirection.horizontal,
        content: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(40))
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: Colors.amber
              ),
              Gap(7.5),
              Text(
                'Local emergency services alerted',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        ),
        )
      );
    }
    void showEmergencyDialog(){
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
              child: Text(
                'Call',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8)
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => showAlertSentMessage(),
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
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              alignment: Alignment.bottomCenter,
              height: devicePadding.bottom + 45,
              // color: 
              // provider.currentPage == 1 ?
              //   Colors.black.withOpacity(0.1) : 
              //     Colors.white.withOpacity(0.6),
              color : Colors.black.withOpacity(0.1),
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
                    NavBarButtons(isActive: provider.currentPage == 0, icon: CupertinoIcons.cloud_upload, onPressed: () => provider.changeCurrentPage(0),),
                    NavBarButtons(isActive: provider.currentPage == 1, icon: CupertinoIcons.map, onPressed: () => provider.changeCurrentPage(1),),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => showEmergencyDialog(),
                        onLongPress: (){},
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

