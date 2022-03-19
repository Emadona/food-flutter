import 'package:flutter/cupertino.dart';
import 'package:restaurant/src/domin/restaurant.dart';

class Pages {
  final int? currentPage;
  final int? totalPages;
  bool get isLast => currentPage == totalPages;
  final List<Restaurant>? restaurant;

  Pages(
      {@required this.currentPage,
      @required this.totalPages,
      @required this.restaurant});
}
