import 'dart:async';

import 'package:fireye/global/constants/constants.dart';
import 'package:fireye/providers/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
  
  late final AnimatedMapController _animatedMapController = AnimatedMapController(vsync: this,);
  

  Future<dynamic> locationName(LatLng coordinates) async{
    await Future.delayed(const Duration(seconds: 1));
    // var address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(coordinates.latitude, coordinates.longitude));
    var address = await GeocodingPlatform.instance!.placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    return address.first;
  }

  showClosestSatelliteImage(LatLng? pinPosition){
    LatLng closestCoordinate = Constants().findNearestLatLong(pinPosition!);
    String imageLink = Constants.satelliteImages[closestCoordinate]!;
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black,
      elevation: 10,
      barrierColor: Colors.white,
      context: context,
      builder: (context) => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 10,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.5))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      child: Text(
                        'Closest Satellite Image',
                        style: TextStyle(
                          fontFamily: 'SFProBold',
                          fontSize: 34,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        child: Ink(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                          child: const Icon(
                            CupertinoIcons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(15),
                FutureBuilder(
                  future: locationName(pinPosition),
                  builder: (context, snapshot) {
                    return 
                    snapshot.hasData ? 
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            child: Image(
                              image: AssetImage(
                                imageLink,
                              ),
                            ),
                          ),
                          const Gap(15),
                          Text(
                            'Additional Information:\nCoordinates: (${pinPosition.latitude.toStringAsPrecision(3)}°N, ${pinPosition.longitude.toStringAsPrecision(3)}°E)\nLocality: ${snapshot.data.subLocality}\nCity: ${snapshot.data.locality}\nState: ${snapshot.data.administrativeArea}\nPostal Code: ${snapshot.data.postalCode}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5)
                            ),
                          )
                        ],
                      ) : Constants.satelliteImageLoading;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Consumer<GlobalProvider>(
        builder: (context, provider, child) => 
        Scaffold(
          backgroundColor: Colors.white,
          extendBody: true,
          body: Stack(
            children: [
              FlutterMap(
              mapController: _animatedMapController.mapController,
              options: MapOptions(
                backgroundColor: Colors.transparent,
                initialCenter: const LatLng(23.2032, 77.0844),
                initialZoom: 5,
                onTap: (tapPosition, point) => provider.changeMarkerPosition(point, _animatedMapController),
                // onTap: (tapPosition, point) => _animatedMapController.mapController.move(point, _animatedMapController.mapController.camera.zoom)
              ),
              children: [
                TileLayer(
                  retinaMode: false,
                  urlTemplate: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.supitsparth.fireye',
                  // wmsOptions: WMSTileLayerOptions(
                  //   // baseUrl: 'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                  //   // baseUrl: 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  //   // baseUrl: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
                  // ),
                ),
                provider.pinPosition != null ? 
                  MarkerLayer(
                    markers: [
                      Marker(
                        rotate: false,
                        point: provider.pinPosition!,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          CupertinoIcons.map_pin,
                          color: Colors.red,
                          // shadows: [Shadow(color: Colors.black, blurRadius: 20, offset: )],
                          size: 35,
                        ),
                      ) 
                    ],
                  ) : const SizedBox(),
              ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: devicePadding.top + 5
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const IgnorePointer(
                            ignoring: true,
                            child: Text(
                              'Maps',
                              style: TextStyle(
                                fontFamily: 'SFProBold',
                                color: Colors.black,
                                fontSize: 34
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () { 
                              LatLng nearest = Constants().findNearestLatLong(const LatLng(26.2006, 92.9376));
                              print('assam\'s coordinates: ${nearest}\nNearest location:');
                              print(Constants.satelliteImages[nearest]);
                            },
                            child: Icon(
                              CupertinoIcons.info,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: provider.pinPosition == null,
                    child: AnimatedOpacity(
                      opacity: provider.pinPosition!=null ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: devicePadding.bottom + 10),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 7.5),
                          padding: const EdgeInsets.all(7.5),
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => showClosestSatelliteImage(provider.pinPosition),
                                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                                    child: Ink(
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Fetch',
                                          style: TextStyle(
                                            fontFamily: 'SFProBold',
                                            color: Colors.black, 
                                            fontSize: 18
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(7.5),
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => provider.removeMarkerPosition(_animatedMapController),
                                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                                    child: Ink(
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.clear,
                                        color: Colors.white,
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


