import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(1.3103491560618676, 103.79507581945782),
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              // Display map tiles from any source
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // OSMF's Tile Server
              userAgentPackageName: 'com.example.app',
              // And many more recommended properties!
            ),
            RichAttributionWidget(
              // Include a stylish prebuilt attribution widget that meets all requirments
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse(
                      'https://openstreetmap.org/copyright')), // (external)
                ),
                // Also add images...
              ],
            ),
            MarkerLayer(markers: [
              Marker(
                point: LatLng(1.3103491560618676, 103.79507581945782),
                alignment: Alignment.center,
                width: 160.w,
                height: 100.h,
                child: Column(
                  children: [
                    Text(
                      "BeautyWorld(美世界店)",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.red,
                      size: 40.w,
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      );
}
