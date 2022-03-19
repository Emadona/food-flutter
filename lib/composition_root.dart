import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:food/chache/local_store.dart';
import 'package:food/fake_restaurant_api.dart';
import 'package:food/states_mangement/auth/auth_cubit.dart';
import 'package:food/states_mangement/helpers/header_cubit.dart';
import 'package:food/states_mangement/restaurant/restaurant_cubit.dart';
import 'package:food/ui/pages/auth/auth_page.dart';
import 'package:food/ui/pages/home/home_page_adapter.dart';
import 'package:restaurant/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'chache/local_store_contract.dart';
import 'ui/pages/home/restaurant_list_page.dart';
import 'ui/pages/restaurant/restaurant_page.dart';
import 'ui/pages/search_results/search_results_adapter.dart';
import 'ui/pages/search_results/search_results_page.dart';

class CompositionRoot {
  static SharedPreferences? _sharedPreferences;
  static ILocalStore? _localStore;
  static String? _baseUrl;
  static Client? _client;
  // static SecureClient _secureClient;
  static FakeRestaurantApi? _api;
  static AuthManager? _manager;
  static IAuthApi? _authApi;

  static configure() {
    _localStore = LocalStore(_sharedPreferences);
    _client = Client();
    _baseUrl = 'http://172.21.176.1:3000';
    // _secureClient = SecureClient(HttpClientOmp(_client), _localStore);
    _api = FakeRestaurantApi(20);
    _authApi = AuthApi(_baseUrl!, _client!);
    _manager = AuthManager(_authApi!);
  }

  static Widget composeAuth() {
    // IAuthApi _api = AuthApi(_baseUrl!, _client!);
    // AuthManager _manager = AuthManager(_api);
    ISignUpService _signUpService = SignUpService(_authApi!);
    AuthCubit _authCubit = AuthCubit(_localStore!);
    // IAuthPageAdapter _adapter =
    return CubitProvider(
      create: (BuildContext context) => _authCubit,
      child: AuthPage(_manager, _signUpService),
    );
  }

  static Widget composeHomeUi() {
    FakeRestaurantApi _api = FakeRestaurantApi(20);
    RestaurantCubit _restaurantCubit =
        RestaurantCubit(_api, defaultPageSize: 5);
    IhomePageAdapter _adapter = HomePageAdapter(
        onSelction: _composeRestaurantPageWith,
        onSearch: _composeSearchResultsPageWith);

    return MultiCubitProvider(providers: [
      CubitProvider<RestaurantCubit>(
          create: (BuildContext context) => _restaurantCubit),
      CubitProvider<HeaderCubit>(
          create: (BuildContext context) => HeaderCubit()),
    ], child: RestaurantListPage(_adapter));
  }

  static Widget _composeSearchResultsPageWith(String query) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 10);
    ISearchResultsPageAdapter searchResultsPageAdapter =
        SearchResultsPageAdapter(onSelection: _composeRestaurantPageWith);
    return SearchResultsPage(restaurantCubit, query, searchResultsPageAdapter);
  }

  static Widget _composeRestaurantPageWith(Restaurant restaurant) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 10);
    return RestaurantPage(restaurant, restaurantCubit);
  }
}
