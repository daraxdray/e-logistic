import 'package:supercharged/supercharged.dart';

class User {
  int id;

  String name;
  String email;
  String phone;
  String photo;
  String role;
  int vendorId;
  double rating;
  bool isOnline = false;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.role,
    this.vendorId,
    this.rating,
    this.isOnline,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photo = json['photo'] ?? "";
    role = json['role_name'] ?? "client";
    vendorId = json['vendor_id'];
    rating = json['rating'].toString().toDouble() ?? 5.00;
    isOnline = (json['is_online'].toString().toInt() ?? 0) == 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'role_name': role,
      'vendor_id': vendorId,
      'rating': rating,
      'is_online': isOnline ? 1 : 0,
    };
  }
}
