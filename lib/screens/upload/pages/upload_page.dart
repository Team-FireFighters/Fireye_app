import 'package:fireye/global/constants/constants.dart';
import 'package:fireye/global/helpers/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context); 
    Size size = MediaQuery.of(context).size;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          devicePadding.top + 5,
          16,
          0
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upload',
                  style: TextStyle(
                    fontFamily: 'SFProBold',
                    color: Colors.white,
                    fontSize: 34
                  ),
                ),
                Icon(
                  CupertinoIcons.info_circle,
                  color: Color.fromARGB(180, 255, 255, 255),
                )
              ],
            ),
            const Gap(20),
            InkWell(
              onTap: (){
              },
              splashColor: Colors.black.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width - 32,
                    height: 3 * (size.width - 32) / 4,
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
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black
                        ]
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
              padding: const EdgeInsets.only(top: 15, left: 0, right: 0),
              child: Text(
                Constants.uploadInfo,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.4)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}