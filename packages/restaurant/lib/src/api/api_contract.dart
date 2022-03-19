import 'package:flutter/foundation.dart';
import 'package:restaurant/src/api/page.dart';
import 'package:restaurant/src/domin/menu.dart';
import 'package:restaurant/src/domin/restaurant.dart';

abstract class IRestaurantApi {
  Future<Pages> getAllRestaurants(@required int page, @required int pageSize);
  Future<Pages> getRestaurantByLocation(
      @required int page, @required int pageSize, @required Location location);
  Future<Pages> findRestaurants(
      @required int page, @required int pageSize, @required searchTerm);
  Future<Restaurant> getRestaurant(@required String id);
  Future<List<Menu>> getMenuRestaurant(@required String restaurantId);
}
