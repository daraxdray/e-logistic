import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class RouteButton extends StatelessWidget {
  const RouteButton(
    this.vendor, {
    this.lat,
    this.lng,
    Key key,
  }) : super(key: key);

  final Vendor vendor;
  final double lat;
  final double lng;
  @override
  Widget build(BuildContext context) {
    return Icon(
      FlutterIcons.navigation_fea,
      size: 24,
      color: Colors.white,
    ).p8().box.color(AppColor.primaryColor).roundedSM.make().onInkTap(() async {
      //
      if (await MapLauncher.isMapAvailable(MapType.google)) {
        await MapLauncher.showDirections(
          mapType: MapType.google,
          destination: Coords(
            vendor != null ? double.parse(vendor.latitude) : lat,
            vendor != null ? double.parse(vendor.longitude) : lng,
          ),
          destinationTitle: vendor != null ? vendor.name : "",
        );
      } else if (await MapLauncher.isMapAvailable(MapType.apple)) {
        await MapLauncher.showDirections(
          mapType: MapType.apple,
          destination: Coords(
            vendor != null ? double.parse(vendor.latitude) : lat,
            vendor != null ? double.parse(vendor.longitude) : lng,
          ),
          destinationTitle: vendor != null ? vendor.name : "",
        );
      } else {
        String googleUrl = 'comgooglemaps://?center=$lat,$lng';
        String appleUrl = 'https://maps.apple.com/?sll=$lat,$lng';
        if (await canLaunch("comgooglemaps://")) {
          await launch(googleUrl);
        } else if (await canLaunch(appleUrl)) {
          await launch(appleUrl);
        } else {
          throw 'Could not launch url';
        }
      }
    });
  }
}
