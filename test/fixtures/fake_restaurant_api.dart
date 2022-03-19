import 'package:faker/faker.dart' as ff;
import 'package:restaurant/restaurant.dart';

class FakeRestaurantApi implements IRestaurantApi {
  late List<Restaurant> _restaurants;

  FakeRestaurantApi(int numberOfRestaurants) {
    final faker = ff.Faker();
    _restaurants = List.generate(
        numberOfRestaurants,
        (index) => Restaurant(
            id: index.toString(),
            name: faker.company.name(),
            displayImgUrl: faker.internet.httpUrl(),
            type: faker.food.cuisine(),
            location: Location(
                longitude: faker.randomGenerator.integer(5).toDouble(),
                latitude: faker.randomGenerator.integer(5).toDouble()),
            address: Address(
                street: faker.address.streetName(),
                city: faker.address.city(),
                parish: faker.address.country())));
  }

  @override
  Future<Pages> findRestaurants(int page, int pageSize, searchTerm) async {
    final filter = searchTerm != null
        ? (Restaurant res) => res.name!.contains(searchTerm)
        : null;
    return _paginatedRestaurants(page, pageSize, filter: filter);
  }

  @override
  Future<Pages> getAllRestaurants(int? page, int? pageSize) async {
    return _paginatedRestaurants(page!, pageSize!);
  }

  @override
  Future<List<Menu>> getMenuRestaurant(String restaurantId) {
    throw UnimplementedError();
  }

  @override
  Future<Restaurant> getRestaurant(String id) async {
    return this
        ._restaurants
        // ignore: unrelated_type_equality_checks, null_check_always_fails
        .singleWhere((restaurant) => restaurant.id == id, orElse: () => null!);
  }

  @override
  Future<Pages> getRestaurantByLocation(
      int page, int pageSize, Location location) {
    throw UnimplementedError();
  }

  Pages _paginatedRestaurants(int page, int pageSize,
      {bool Function(Restaurant)? filter}) {
    final int offSet = (page - 1) * pageSize;
    final restaurants = filter == null
        ? this._restaurants
        : this._restaurants.where(filter).toList();
    final totalPages = (restaurants.length / pageSize).ceil();
    final result = restaurants.skip(offSet).take(pageSize).toList();
    return Pages(currentPage: page, totalPages: totalPages, restaurant: result);
  }
}
