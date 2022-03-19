// ignore_for_file: null_check_always_fails
import 'dart:convert';

import 'package:common/common.dart';
import 'package:restaurant/src/api/api_contract.dart';
import 'package:restaurant/src/api/page.dart';
import 'package:restaurant/src/domin/menu.dart';
import 'package:restaurant/src/domin/restaurant.dart';
import 'package:http/http.dart';

import 'mapper.dart';

class RestaurantApi implements IRestaurantApi {
  final IHttpClient httpClient;
  final String baseUrl;

  RestaurantApi(this.baseUrl, this.httpClient);
  @override
  Future<Pages> findRestaurants(int page, int pageSize, searchTerm) async {
    final endpoind = Uri.parse(
        baseUrl + '/restaurant/page=$page&limit=$pageSize&term=$searchTerm');
    final result = await httpClient.get(endpoind);
    return _parseRestaurantsJson(result);
  }

  @override
  Future<Pages> getAllRestaurants(
    int page,
    int pageSize,
  ) async {
    Uri endPoint =
        Uri.parse(baseUrl + 'restaurants/page=$page&limit=$pageSize');
    var result = await httpClient.get(endPoint);
    return _parseRestaurantsJson(result);
  }

  @override
  Future<List<Menu>> getMenuRestaurant(String restaurantId) async {
    final endpoint = Uri.parse(baseUrl + '/restauranrt/menu/$restaurantId');
    final result = await httpClient.get(endpoint);
    return _parseRestaurantsMenuJson(result);
  }

  @override
  Future<Restaurant> getRestaurant(String id) async {
    Uri endPoint = Uri.parse(baseUrl + '/restaurants/restaurant/$id');
    final result = await httpClient.get(endPoint);
    if (result.status == Status.failure) return null!;
    final json = jsonDecode(result.data!);
    return Mapper.fromJson(json);
  }

  @override
  Future<Pages> getRestaurantByLocation(
      int page, int pageSize, location) async {
    Uri endPoint = Uri.parse(baseUrl +
        'restaurants/page=$page&limit=$pageSize&logitude=${location.longitude}&latitude=${location.latitude}');
    var result = await httpClient.get(endPoint);
    return _parseRestaurantsJson(result);
  }

  List<Menu> _parseRestaurantsMenuJson(HttpResult result) {
    if (result.status == Status.failure) return null!;
    final json = jsonDecode(result.data!);
    return json['menu'] != null ? _restaurantsMenuFromJson(json) : [];
  }

  Pages _parseRestaurantsJson(HttpResult result) {
    if (result.status == Status.failure) return null!;
    final json = jsonDecode(result.data!);
    final List<Restaurant> restaurants =
        json['restaurants'] != null ? _restaurantsFromJson(json) : [];

    return Pages(
        currentPage: json['metadata']['page'],
        totalPages: json['metadata']['total_pages'],
        restaurant: restaurants);
  }

  _restaurantsMenuFromJson(Map<String, dynamic> json) {
    final List menu = json['menu'];
    return menu.map<Menu>((e) => Mapper.fromMenuJson(e)).toList();
  }

  List<Restaurant> _restaurantsFromJson(Map<String, dynamic> json) {
    final List restaurants = json['restaurants'];
    return restaurants.map<Restaurant>((e) => Mapper.fromJson(e)).toList();
  }
}
