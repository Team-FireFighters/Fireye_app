import 'dart:io';

import 'package:fireye/global/constants/constants.dart';
import 'package:fireye/global/helpers/app_colors.dart';
import 'package:fireye/providers/global_provider.dart';
import 'package:fireye/services/select_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin{
  void toggleMessagingServiceDialog(GlobalProvider provider){
    bool enabled = provider.messagingServiceEnabled;
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>  CupertinoAlertDialog(
        title: const Text(
          'Messaging Service',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(5),
            Text(
              !enabled? 
              'Enable Messaging Service?' : 'Disable Messaging Service?',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const Gap(5),
            Text(
              'Note: This action will ${enabled?'disable':'enable'} emergency messaging service',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              enabled ? 
                provider.disableMessagingService() : 
                  provider.enableMessagingService();
              enabled = provider.messagingServiceEnabled;
              Constants().showSnackBarMessage(
                context, 
                customMessage: enabled ? 
                  'Messaging service is enabled' 
                    : 'Messaging service is disabled',
              );
            },
            isDestructiveAction: true,
            child: Text(
              enabled ? 'Disable' : 'Enable',
              style: TextStyle(
                color: enabled ? AppColors.redAlt : Colors.lightGreen
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    super.build(context); 
    Size size = MediaQuery.of(context).size;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Consumer<GlobalProvider>(
        builder: (context, provider, child) => 
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              0
            ),
            child: SingleChildScrollView(
              controller: provider.uploadPageScrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(devicePadding.top + 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upload',
                        style: TextStyle(
                          fontFamily: 'SFProBold',
                          color: Colors.white,
                          fontSize: 34
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () => toggleMessagingServiceDialog(provider),
                        onDoubleTap: () =>
                          Constants().showSnackBarMessage(
                            context, 
                            disablePop: true,
                            customMessage: provider.messagingServiceEnabled ? 
                              'Messaging service is enabled' 
                                : 'Messaging service is disabled',
                          ),
                        child: const Icon(
                          CupertinoIcons.info_circle,
                          color: Color.fromARGB(180, 255, 255, 255),
                        ),
                      )
                    ],
                  ),
                  const Gap(20),
                  InkWell(
                    onTap: () => Services().selectFile(provider),
                    splashColor: Colors.black.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: size.width - 32,
                          height: 3 * (size.width - 32) / 4,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top : Radius.circular(20)),
                            image: DecorationImage(
                              image: NetworkImage('https://i.pinimg.com/564x/eb/b5/50/ebb55044546ffc16e8528500c6252369.jpg'),
                              fit: BoxFit.cover
                            ),
                          ),
                          foregroundDecoration: const BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.bottomLeft,
                              radius: 1.6,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                                Colors.black
                              ]
                            ),
                          ),
                          child: Text(
                            'Fireye',
                            style: TextStyle(
                              fontFamily: 'SFProBlack',
                              fontStyle: FontStyle.italic,
                              fontSize: size.width/5,
                              color: Colors.white
                            ),
                          ),
                        ),
                        Ink(
                          width: size.width - 32,
                          height: (size.width - 32) / 4,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                            color: Colors.white.withOpacity(0.9)
                          ),
                          child: const Icon(
                            CupertinoIcons.arrow_up_doc,
                            color: Colors.black,
                          )
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 0, right: 0, bottom: 15),
                    child: Text(
                      Constants.uploadInfo,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.4)
                      ),
                    ),
                  ),
      
                  provider.pickedFile != null ? 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Selected File',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFProBold',
                            fontSize: 26
                          ),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                              child: Image.file(
                                File(provider.pickedFile!.path!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.075),
                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(15)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Center(
                                          child: Text(
                                            provider.pickedFile!.name,
                                            style: const TextStyle(
                                              fontFamily: 'SFProBold',
                                              fontSize: 17,
                                              overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        provider.removeFile();
                                        provider.removeFireResponse();
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.clear,
                                        color: Colors.red,
                                      )
                                    ),
                                    const Gap(5)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        InkWell(
                          onTap: () => Services().detectFirePhoto(provider),
                          splashColor: Colors.black.withOpacity(0.25),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          child: Ink(
                            width: double.infinity,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 228, 20),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: const Center(
                              child: Text(
                                'Detect',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProBold',
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ) : const SizedBox(),
                  const Gap(20),
                  provider.fireResponse != null ? 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Message from Server:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5)
                        ),
                      ),
                      Text(
                        Constants.fireResponseDecode[provider.fireResponse]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'SFProBold'
                        ),
                      ),
                    ],
                  ) : provider.detectionStarted ? 
                      Constants.loadingWidget : 
                        const SizedBox(),
                  const Gap(20),
                  const Gap(200)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}