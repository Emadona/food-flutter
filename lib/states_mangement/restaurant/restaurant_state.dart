import 'package:equatable/equatable.dart';
import 'package:restaurant/restaurant.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
}

class Initial extends RestaurantState {
  const Initial();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends RestaurantState {
  const Loading();
  @override
  List<Object?> get props => [];
}

class PageLoaded extends RestaurantState {
  List<Restaurant>? get restaurants => _page.restaurant;
  final Pages _page;
  int? get nextPage => _page.isLast ? null : this._page.currentPage! + 1;
  const PageLoaded(this._page);
  @override
  List<Object?> get props => [_page];
}

class RestaurantLoaded extends RestaurantState {
  final Restaurant restaurant;
  const RestaurantLoaded(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

class MenuLoaded extends RestaurantState {
  final List<Menu> menu;
  const MenuLoaded(this.menu);

  @override
  List<Object?> get props => [menu];
}

class ErrorRestaurant extends RestaurantState {
  final String message;
  const ErrorRestaurant(this.message);

  @override
  List<Object?> get props => [message];
}
