import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

class Restaurant {
  String? id;
  String? name;
  String? displayImgUrl;
  String? type;
  Location? location;
  Address? address;

  Restaurant(
      {@required this.id,
      @required this.name,
      @required this.displayImgUrl,
      @required this.type,
      @required this.location,
      @required this.address});
}

class Location extends Equatable {
  double? longitude;
  double? latitude;

  Location({@required this.longitude, @required this.latitude});

  @override
  List<Object?> get props => [longitude, latitude];
}

class Address extends Equatable {
  String? street;
  String? city;
  String? parish;
  String? zone;

  Address(
      {@required this.street,
      @required this.city,
      @required this.parish,
      this.zone});

  @override
  List<Object?> get props => [street, city, parish, zone];
}
