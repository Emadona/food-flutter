import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantListItem(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    child: Container(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12.0,),
          Padding(padding: const EdgeInsets.only(right: 16,left: 16),
          child: Text(
            restaurant.name.toString(),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline5,
          ),),
          SizedBox(height: 12,),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Text(
              "${restaurant.address!.street}, ${restaurant.address!.city}, ${restaurant.address!.parish}",
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.black54),
            ),
          ),
          SizedBox(height: 8,),
          RatingBarIndicator(
            rating: 4.5,
            itemBuilder: (context, index)=> Icon(
              Icons.stars_rounded,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 50.0,
          ),
          Text('4.5', style: Theme.of(context).textTheme.headline5,),
          SizedBox(height: 8.0,),
          Wrap(spacing: 8.0,runSpacing: 4.0,children: [
            _createChip('Vegetarian', context),
            _createChip('Vegan', context),
          ],),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).accentColor,
            blurRadius: 0,
            offset: const Offset(5, 5),
          ),
        ],
      ),
    ),);
  }

  Widget _createChip(String label, BuildContext context){
    return Chip(
      backgroundColor: Colors.black87,
      label: Text(
        label,
        style: Theme.of(context).textTheme.subtitle1!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
