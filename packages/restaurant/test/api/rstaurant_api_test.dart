// @dart=2.9
import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant/src/api/api_contract.dart';
import 'package:restaurant/src/api/restaurant_api.dart';
import 'package:restaurant/src/domin/restaurant.dart';

class HttpClient extends Mock implements IHttpClient {}

void main() {
  HttpClient httpClient;
  IRestaurantApi sut;

  setUp(() {
    httpClient = HttpClient();
    sut = RestaurantApi('baseUrl', httpClient);
  });

  group('resturant api', () {
    test('return an empty list when no restaurans are found', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode({
            'metadata': {'page': 1, 'limit': 2},
            'restaurants': []
          }),
          status: Status.success));

      var result = await sut.getAllRestaurants(1, 2);

      expect(result.restaurant, []);
    });

    test('return an empty list when status code is not 200', () async {
      when(httpClient.get(any)).thenAnswer((_) async =>
          HttpResult(data: jsonEncode({}), status: Status.failure));

      var result = await sut.getAllRestaurants(1, 2);

      expect(result, isNull);
    });

    test('return list of restaurants when success', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(_restauransJson()), status: Status.success));

      final result = await sut.getAllRestaurants(1, 2);
      expect(result.restaurant, isNotEmpty);
    });
  });

  group('find restaurant', () {
    test('return an empty list when no restaurans are found', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode({
            'metadata': {'page': 1, 'limit': 2},
            'restaurants': []
          }),
          status: Status.success));

      var result = await sut.findRestaurants(1, 2, 'g');

      expect(result.restaurant, []);
    });

    test('return an empty list when status code is not 200', () async {
      when(httpClient.get(any)).thenAnswer((_) async =>
          HttpResult(data: jsonEncode({}), status: Status.failure));

      var result = await sut.findRestaurants(1, 2, '12345');

      expect(result, isNull);
    });

    test('return list of restaurants when success', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(_restauransJson()), status: Status.success));

      final result = await sut.findRestaurants(1, 2, '12345');
      expect(result.restaurant, isNotEmpty);
    });
  });

  group('find menus restaurant', () {
    test('return an empty list when no menu restauran are found', () async {
      when(httpClient.get(any)).thenAnswer((_) async =>
          HttpResult(data: jsonEncode({'menu': []}), status: Status.success));

      var result = await sut.getMenuRestaurant('g');

      expect(result, []);
    });

    test('return an empty list when status code is not 200', () async {
      when(httpClient.get(any)).thenAnswer((_) async =>
          HttpResult(data: jsonEncode({}), status: Status.failure));

      var result = await sut.getMenuRestaurant('12345');

      expect(result, isNull);
    });

    test('return list of menus when success', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode({'menu': _menuRestauransJson()}),
          status: Status.success));

      final result = await sut.getMenuRestaurant('12345');

      expect(result, isNotEmpty);
    });
  });

  Location location = Location(longitude: 333.0, latitude: 334.0);

  group('get resturant by location', () {
    test('return an empty list when no restaurans are found', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode({
            'metadata': {'page': 1, 'limit': 2},
            'restaurants': []
          }),
          status: Status.success));
      Location location = Location(longitude: 333.0, latitude: 334.0);
      var result = await sut.getRestaurantByLocation(1, 2, location);

      expect(result.restaurant, []);
    });

    test('return an empty list when status code is not 200', () async {
      when(httpClient.get(any)).thenAnswer((_) async =>
          HttpResult(data: jsonEncode({}), status: Status.failure));

      var result = await sut.getRestaurantByLocation(1, 2, location);

      expect(result, isNull);
    });

    test('return list of restaurants when success', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(_restauransJson()), status: Status.success));

      final result = await sut.getRestaurantByLocation(1, 1, location);
      expect(result.restaurant, isNotEmpty);
    });
  });

  group('getRestaurant', () {
    test('return null when restaurant not found', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode({'error': 'restaurant not found'}),
          status: Status.failure));

      final result = await sut.getRestaurant('123');
      expect(result, null);
    });

    test('returns restaurant when success', () async {
      when(httpClient.get(any)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(_restauransJson()["restaurants"][0]),
          status: Status.success));
      final result = await sut.getRestaurant('12345');

      expect(result, isNotNull);
      expect(result.id, '12345');
    });
  });
}

_restauransJson() {
  return {
    'metadata': {'page': 1, 'limit': 2},
    'restaurants': [
      {
        "id": "12345",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "image_url": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "parish": "Parish",
          "zone": "Zone"
        }
      },
      {
        "id": "12666",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "imageUrl": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "parish": "Parish",
          "zone": "Zone"
        }
      }
    ]
  };
}

_menuRestauransJson() {
  return [
    {
      "id": "12666",
      "name": "Restuarant Name",
      "imageUrl": "restaurant.jpg",
      "description": "description",
      'items': [
        {
          'name': 'item name 1',
          "description": "description",
          'unitPrice': 44.0,
          'image_urls': ['url1', 'url2']
        }
      ]
    },
    {
      "id": "123",
      "name": "Restuarant Name",
      "imageUrl": "restaurant.jpg",
      "description": "description",
      'items': [
        {
          'name': 'item name 1',
          "description": "description",
          'unitPrice': 44.0,
          'image_urls': ['url1', 'url2']
        }
      ]
    }
  ];
}
