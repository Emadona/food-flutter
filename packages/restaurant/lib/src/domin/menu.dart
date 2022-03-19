import 'package:flutter/foundation.dart';

class Menu {
  final String? id;
  final String? name;
  final String? desplayImgUrl;
  final String? description;
  final List<MenuItem>? items;

  Menu(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.items,
      this.desplayImgUrl});
}

class MenuItem {
  String? name;
  String? description;
  List<String>? imageUrls;
  double? unitPrice;

  MenuItem(
      {@required this.name,
      @required this.description,
      this.imageUrls,
      @required this.unitPrice});
}
