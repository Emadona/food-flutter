import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/restaurant.dart';

abstract class ISearchResultsPageAdapter {
  onRestaurantsSelected(BuildContext context, Restaurant restaurant);
}

class SearchResultsPageAdapter implements ISearchResultsPageAdapter {
  final Widget Function(Restaurant restaurant)? onSelection;

  SearchResultsPageAdapter({@required this.onSelection});
  @override
  void onRestaurantsSelected(BuildContext context, Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => onSelection!(restaurant)),
    );
  }
}
