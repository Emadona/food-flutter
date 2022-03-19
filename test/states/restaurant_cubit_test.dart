import 'package:flutter_test/flutter_test.dart';
import 'package:food/states_mangement/restaurant/restaurant_cubit.dart';
import 'package:food/states_mangement/restaurant/restaurant_state.dart';

import '../fixtures/fake_restaurant_api.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  RestaurantCubit? sut;
  FakeRestaurantApi api;

  setUp(() {
    api = FakeRestaurantApi(19);
    sut = RestaurantCubit(api, defaultPageSize: 10);
  });

  tearDown(() {
    sut!.close();
  });

  group('getAllRestaurants', () {
    test('returns first page with correct number of restaurants', () async {
      sut!.getAllRestaurants(page: 1);
      await expectLater(sut, emits(matcher.TypeMatcher<PageLoaded>()));
      final state = sut!.state as PageLoaded;
      expect(state.nextPage, equals(2));
      print('length = ' + state.restaurants!.length.toString());
      expect(state.restaurants!.length, 10);
    });

    test('returns last page with correct number of restaurants', () async {
      sut!.getAllRestaurants(page: 2);
      await expectLater(sut, emits(matcher.TypeMatcher<PageLoaded>()));
      final state = sut!.state as PageLoaded;
      expect(state.nextPage, equals(null));
      expect(state.restaurants!.length, 9);
    });
  });

  group('getRestaurant', () {
    test('return restaurant when found', () async {
      sut!.getRestaurant('1');
      await expectLater(
          sut, emits(const matcher.TypeMatcher<RestaurantLoaded>()));
      final state = sut!.state as RestaurantLoaded;
      expect(state.restaurant, isNotNull);
    });

    test('returns error when restaurant not found', () async {
      sut!.getRestaurant('-1');
      await expectLater(
          sut, emits(const matcher.TypeMatcher<ErrorRestaurant>()));
      final state = sut!.state as ErrorRestaurant;
      expect(state.message, isNotNull);
    });
  });
}
