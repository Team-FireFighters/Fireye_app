import 'package:fireye/global/helpers/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Stack(
          children: [
            FlutterMap(
            options: const MapOptions(
              backgroundColor: Colors.black,
              initialCenter: LatLng(23.2032, 77.0844),
              initialZoom: 5,
            ),
            children: [
              TileLayer(
                retinaMode: false,
                // urlTemplate: 'https://tiles.mapbox.com/v3/mapbox.control-room/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                wmsOptions: WMSTileLayerOptions(
                  baseUrl: 'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                ),
              ),
            ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  top: devicePadding.top + 5
                ),
                child: const Text(
                  'Maps',
                  style: TextStyle(
                    fontFamily: 'SFProBold',
                    color: Colors.white,
                    fontSize: 34
                  ),
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