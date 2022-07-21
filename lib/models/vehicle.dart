// To parse this JSON data, do
//
//     final vehicle = vehicleFromJson(jsonString);

import 'dart:convert';
import 'package:supercharged/supercharged.dart';

Vehicle vehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));

String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
  Vehicle({
    this.id,
    this.carModelId,
    this.driverId,
    this.vehicleTypeId,
    this.regNo,
    this.color,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.formattedDate,
    this.formattedUpdatedDate,
    this.photo,
    this.carModel,
    this.vehicleType,
  });

  int id;
  int carModelId;
  int driverId;
  int vehicleTypeId;
  String regNo;
  String color;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedDate;
  String formattedUpdatedDate;
  String photo;
  CarModel carModel;
  VehicleType vehicleType;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"],
      carModelId: json["car_model_id"],
      driverId: json["driver_id"],
      vehicleTypeId: json["vehicle_type_id"],
      regNo: json["reg_no"],
      color: json["color"],
      isActive: json["is_active"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      formattedDate: json["formatted_date"],
      formattedUpdatedDate: json["formatted_updated_date"],
      photo: json["photo"],
      carModel: CarModel.fromJson(json["car_model"]),
      vehicleType: VehicleType.fromJson(json["vehicle_type"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "car_model_id": carModelId,
        "driver_id": driverId,
        "vehicle_type_id": vehicleTypeId,
        "reg_no": regNo,
        "color": color,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "formatted_updated_date": formattedUpdatedDate,
        "photo": photo,
        "car_model": carModel.toJson(),
        "vehicle_type": vehicleType.toJson(),
      };
}

class CarModel {
  CarModel({
    this.id,
    this.name,
    this.carMakeId,
    this.carMake,
  });

  int id;
  String name;
  int carMakeId;
  CarMake carMake;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"],
        name: json["name"],
        carMakeId: json["car_make_id"],
        carMake: CarMake.fromJson(json["car_make"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "car_make_id": carMakeId,
        "car_make": carMake.toJson(),
      };
}

class CarMake {
  CarMake({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory CarMake.fromJson(Map<String, dynamic> json) => CarMake(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}


class VehicleType {
  VehicleType({
    this.id,
    this.name,
    this.slug,
    this.baseFare,
    this.distanceFare,
    this.timeFare,
    this.minFare,
    this.isActive,
    this.formattedDate,
    this.photo,
  });

  int id;
  String name;
  String slug;
  double baseFare;
  double distanceFare;
  double timeFare;
  double minFare;
  int isActive;
  String formattedDate;
  String photo;

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        baseFare: json["base_fare"].toString().toDouble(),
        distanceFare: json["distance_fare"].toString().toDouble(),
        timeFare: json["time_fare"].toString().toDouble(),
        minFare: json["min_fare"].toString().toDouble(),
        isActive: json["is_active"],
        formattedDate: json["formatted_date"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "base_fare": baseFare,
        "distance_fare": distanceFare,
        "time_fare": timeFare,
        "min_fare": minFare,
        "is_active": isActive,
        "formatted_date": formattedDate,
        "photo": photo,
      };
}
