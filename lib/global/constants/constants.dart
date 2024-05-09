import 'package:fireye/global/helpers/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';


class Constants{
  static const String uploadInfo = 'Click the above button to submit a Photo or Video for Fire Detection.\nSupported Formats: PNG, JPG, JPEG, MP4\nMaximum size: 25MB';

  static const Map<int, String> fireResponseDecode = {
    0 : 'No Fire Detected',
    1 : 'Fire Detected',
    2 : 'Fire and Smoke Detected',
  };

  static Map<LatLng, String> satelliteImages = {
    const LatLng(15.9129, 79.7400) : 'assets/satellite/andhra pradesh.png',
    const LatLng(21.2787, 81.8661) : 'assets/satellite/chattisgarh.png',
    const LatLng(15.3173, 75.7139) : 'assets/satellite/karnataka.png',
    const LatLng(24.6637, 93.9063) : 'assets/satellite/manipur.png',
    const LatLng(25.4670, 91.3662) : 'assets/satellite/meghalaya.png',
    const LatLng(23.1645, 92.9376) : 'assets/satellite/mizoram.png',
    const LatLng(20.2376, 84.2700) : 'assets/satellite/odisha.png',
    const LatLng(18.5204, 73.8567) : 'assets/satellite/pune.png',
    const LatLng(18.1124, 79.0193) : 'assets/satellite/telangana.png',
    const LatLng(23.5639, 91.6761) : 'assets/satellite/tripura.png',
  };

  static List<LatLng> stateCoordinates = [
    const LatLng(15.9129, 79.7400),
    const LatLng(21.2787, 81.8661),
    const LatLng(15.3173, 75.7139),
    const LatLng(24.6637, 93.9063),
    const LatLng(25.4670, 91.3662),
    const LatLng(23.1645, 92.9376),
    const LatLng(20.2376, 84.2700),
    const LatLng(18.5204, 73.8567),
    const LatLng(18.1124, 79.0193),
    const LatLng(23.5639, 91.6761) 
  ];

  LatLng findNearestLatLong(LatLng coordinates){
    LatLng closest = stateCoordinates[0];
    for(LatLng i in stateCoordinates){
      double temp = const Distance().as(LengthUnit.Meter, i, coordinates);
      double currentDistance = const Distance().as(LengthUnit.Meter, coordinates, closest);
      if (temp < currentDistance){
        closest = i;
      }
    }
    return closest;
    // now map this closest to satellite images
  }

  static Widget loadingWidget = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(
        child: Text(
          'Uploading your file to the server and running ML algorithms for fire detection.',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.7),
          ),
          softWrap: true,
        ),
      ),
      const Gap(5),
      const CupertinoActivityIndicator()
    ],
  );
  static Widget satelliteImageLoading = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(
        child: Text(
          'Fetching Satellite Image from Server',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.7),
          ),
          softWrap: true,
        ),
      ),
      const Gap(5),
      const CupertinoActivityIndicator()
    ],
  );

  String googleMapsSearch(LatLng latLng){
  return "https://www.google.com/maps/search/${latLng.latitude},+${latLng.longitude}+google+maps?sa=X&ved=1t:242&ictx=111";
  }

  void showSnackBarMessage(BuildContext context, {String? customMessage, disablePop = false}) {
    !disablePop? Navigator.of(context).pop() : null;
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 30, 30, 30),
          borderRadius: BorderRadius.all(Radius.circular(40))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: Colors.amber
            ),
            const Gap(7.5),
            Flexible(
              child: Text(
                customMessage??'Local emergency services alerted',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}