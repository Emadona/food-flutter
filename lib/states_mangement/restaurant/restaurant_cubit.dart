import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:food/states_mangement/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final IRestaurantApi _api;
  final int _pageSize;

  RestaurantCubit(this._api, {int defaultPageSize = 30})
      : _pageSize = defaultPageSize,
        super(Initial());

  getAllRestaurants({@required int? page}) async {
    _startLoading();
    final pageResult = await _api.getAllRestaurants(page!, _pageSize);
    pageResult == null || pageResult.restaurant!.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(pageResult);
  }

  getRestaurantByLocation(int page, Location location) async {
    _startLoading();
    final pageResult =
        await _api.getRestaurantByLocation(page, _pageSize, location);
    pageResult == null || pageResult.restaurant!.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(pageResult);
  }

  search(int page, String query) async {
    final pageResult = await _api.findRestaurants(page, _pageSize, query);
    pageResult == null || pageResult.restaurant!.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(pageResult);
  }

  getRestaurant(String id) async {
    final pageResult = await _api.getRestaurant(id);
    pageResult == null
        ? emit(ErrorRestaurant('restaurant not found'))
        : emit(RestaurantLoaded(pageResult));
  }

  getRestaurantMenu(String restaurantId) async {
    final menu = await _api.getMenuRestaurant(restaurantId);
    menu == null ? emit(ErrorRestaurant('menu not found')) : emit(MenuLoaded(menu));
  }

  _startLoading() {
    emit(Loading());
  }

  _showError(String? message) {
    emit(ErrorRestaurant(message!));
  }

  _setPageData(Pages page) {
    emit(PageLoaded(page));
  }
}
