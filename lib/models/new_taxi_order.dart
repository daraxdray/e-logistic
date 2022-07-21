// To parse this JSON data, do
//
//     final newTaxiOrder = newTaxiOrderFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/new_order.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:supercharged/supercharged.dart';

NewTaxiOrder newTaxiOrderFromJson(String str) =>
    NewTaxiOrder.fromJson(json.decode(str));

String newTaxiOrderToJson(NewTaxiOrder data) => json.encode(data.toJson());

class NewTaxiOrder {
  NewTaxiOrder({
    this.pickup,
    this.status,
    this.driverId,
    this.id,
    this.code,
    this.vehicleTypeId,
    this.tripDistance,
    this.dropoff,
    this.earthDistance,
  });

  Pickup pickup;
  String status;
  dynamic driverId;
  int id;
  String code;
  int vehicleTypeId;
  double tripDistance;
  Dropoff dropoff;
  double earthDistance;

  factory NewTaxiOrder.fromJson(Map<String, dynamic> json) => NewTaxiOrder(
        pickup: Pickup.fromJson(jsonDecode(json["pickup"])),
        status: json["status"].toString(),
        driverId: json["driver_id"].toString().toInt() ?? null,
        id: json["id"].toString().toInt(),
        code: json["code"].toString(),
        vehicleTypeId: json["vehicle_type_id"].toString().toInt(),
        tripDistance: json["trip_distance"].toString().toDouble(),
        dropoff: Dropoff.fromJson(jsonDecode(json["dropoff"])),
        earthDistance: json["earth_distance"].toString().toDouble(),
      );

  double get pickupDistance {
    return Geolocator.distanceBetween(
          LocationService.currentLocation?.latitude,
          LocationService.currentLocation?.longitude,
          pickup.lat.toDouble(),
          pickup.long.toDouble(),
        ) /
        1000;
  }

  Map<String, dynamic> toJson() => {
        "pickup": pickup.toJson(),
        "status": status,
        "driver_id": driverId,
        "id": id,
        "code": code,
        "vehicle_type_id": vehicleTypeId,
        "trip_distance": tripDistance,
        "dropoff": dropoff.toJson(),
        "earth_distance": earthDistance,
      };
}
