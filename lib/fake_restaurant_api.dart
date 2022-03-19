import 'package:faker/faker.dart' as ff;
import 'package:restaurant/restaurant.dart';

class FakeRestaurantApi implements IRestaurantApi {
  late List<Restaurant> _restaurants;
  late List<Menu> _restaurantMenus = [];
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

    _restaurants.forEach((restaurant) {
      var menus = List.generate(
        faker.randomGenerator.integer(5),
        (index) => Menu(
          id: restaurant.id,
          name: faker.food.dish(),
          description: faker.lorem.sentences(2).join(),
          items: List.generate(
            faker.randomGenerator.integer(15),
            (_) => MenuItem(
              name: faker.food.dish(),
              description: faker.lorem.sentence(),
              unitPrice:
                  faker.randomGenerator.integer(5000, min: 500).toDouble(),
            ),
          ),
        ),
      );
      _restaurantMenus.addAll(menus);
    });
  }

  @override
  Future<Pages> findRestaurants(int page, int pageSize, searchTerm) async {
    final filter = searchTerm != null
        ? (Restaurant res) =>
            res.name!.toLowerCase().contains(searchTerm.toLowerCase().trim())
        : null;
    await Future.delayed(Duration(seconds: 2));
    return _paginatedRestaurants(page, pageSize, filter: filter);
  }

  @override
  Future<Pages> getAllRestaurants(int? page, int? pageSize) async {
    await Future.delayed(Duration(seconds: 2));
    return _paginatedRestaurants(page!, pageSize!);
  }

  @override
  Future<List<Menu>> getMenuRestaurant(String restaurantId) async {
    await Future.delayed(Duration(seconds: 2));
    return _restaurantMenus.where((Menu) => Menu.id == restaurantId).toList();
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
      int page, int pageSize, Location location) async {
    final filter =
        location != null ? (Restaurant res) => res.location == location : null;
    return _paginatedRestaurants(page, pageSize, filter: filter);
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
