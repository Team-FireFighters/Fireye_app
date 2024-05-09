import 'package:fireye/global/helpers/app_colors.dart';
import 'package:fireye/providers/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
  
  late final AnimatedMapController _animatedMapController = AnimatedMapController(vsync: this,);
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
                          Icon(
                            CupertinoIcons.info,
                            color: Colors.black.withOpacity(0.7),
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
                                    onTap: (){},
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