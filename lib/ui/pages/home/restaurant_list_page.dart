import 'package:auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:food/states_mangement/auth/auth_state.dart' as authState;
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:food/models/header.dart';
import 'package:food/states_mangement/auth/auth_cubit.dart';
import 'package:food/states_mangement/auth/auth_state.dart';
import 'package:food/states_mangement/helpers/header_cubit.dart';
import 'package:food/states_mangement/restaurant/restaurant_cubit.dart';
import 'package:food/states_mangement/restaurant/restaurant_state.dart';
import 'package:food/ui/pages/home/home_page_adapter.dart';
import 'package:food/ui/utils/utils.dart';
import 'package:food/ui/widgets/custom_text_field.dart';
import 'package:food/ui/widgets/restaurant_list_item.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantListPage extends StatefulWidget {
  final IhomePageAdapter adapter;
  // final IAuthService service;

  const RestaurantListPage(
    this.adapter,
    // this.service
  );

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  PageLoaded? currentState;
  List<Restaurant>? restaurants = [];
  double currentIndex = 0;
  double previousIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    CubitProvider.of<RestaurantCubit>(context).getAllRestaurants(page: 1);
    super.initState();
    _onScrollListener();
  }

  _onScrollListener() {
    _scrollController.addListener(() {
      currentIndex = (_scrollController.offset.round() / 240).floorToDouble();
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          currentState!.nextPage != null) {
        CubitProvider.of<RestaurantCubit>(context)
            .getAllRestaurants(page: currentState!.nextPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ignore: prefer_const_constructors
        leading: IconButton(
          icon: Icon(
            Icons.power_settings_new_rounded,
            size: 36.0,
          ),
          onPressed: () {
            // _logout();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_basket_outlined,
                size: 38.8,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              child: _header(),
              alignment: Alignment.topCenter,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: CubitConsumer<RestaurantCubit, RestaurantState>(
                  builder: (_, state) {
                    if (state is PageLoaded) {
                      currentState = state;
                      restaurants!.addAll(state.restaurants!);
                      _updateHeader();
                    }

                    if (currentState == null)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return _buildListOfRestaurants();
                  },
                  listener: (context, state) {
                    if (state is ErrorRestaurant) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            // Align(
            //   child: CubitListener<AuthCubit, authState.AuthState>(
            //     child: Container(),
            //     listener: (context, state) {
            //       if (state is authState.LoadingState) {
            //         _showLoader();
            //       }
            //       if (state is authState.ErrorState) {
            //         Scaffold.of(context).showSnackBar(SnackBar(
            //             content: Text(
            //           state.message,
            //           style: Theme.of(context)
            //               .textTheme
            //               .caption!
            //               .copyWith(color: Colors.white, fontSize: 16.0),
            //         )));
            //         _hideLoader();
            //       }
            //     },
            //   ),
            //   alignment: Alignment.center,
            // )
          ],
        ),
      ),
    );
  }

  _header() => Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        height: 350.0,
        child: Stack(
          children: [
            CubitBuilder<HeaderCubit, Header>(
              builder: (_, state) => _buildDynamicHeaderInfo(state),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
                child: CustomTextField(
                  hint: 'find restaurants',
                  fontSize: 14.0,
                  height: 48.0,
                  fontWeight: FontWeight.normal,
                  onChanged: (val) {},
                  inputAction: TextInputAction.search,
                  onSubmitted: (query) {
                    widget.adapter.onSearchQuery(context, query);
                  },
                ),
              ),
            )
          ],
        ),
      );

  _buildDynamicHeaderInfo(Header header) => Stack(
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: header.imageUrl,
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Theme.of(context).accentColor.withOpacity(0.7),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  header.title,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          )
        ],
      );

  _buildListOfRestaurants() {
    return Container(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          if (currentIndex != previousIndex) {
            _updateHeader();
            previousIndex = currentIndex;
          }
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 40.0),
          itemBuilder: (context, index) {
            return index >= restaurants!.length
                ? bottomLoader()
                : GestureDetector(
                    onTap: () => widget.adapter
                        .onRestaurantSelected(context, restaurants![index]),
                    child: RestaurantListItem(restaurants![index]),
                  );
          },
          physics: BouncingScrollPhysics(),
          itemCount: currentState!.nextPage == null
              ? restaurants!.length
              : restaurants!.length + 1,
          controller: _scrollController,
        ),
      ),
    );
  }

  _updateHeader() {
    var restaurant = restaurants![currentIndex.toInt()];
    CubitProvider.of<HeaderCubit>(context)
        .update(restaurant.type!, restaurant.displayImgUrl!);
  }

  _showLoader() {
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
