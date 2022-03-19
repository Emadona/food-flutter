import 'package:restaurant/src/domin/menu.dart';
import 'package:restaurant/src/domin/restaurant.dart';

class Mapper {
  static fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      displayImgUrl: json['displayImageUrl'] ?? '',
      location: Location(
        latitude: json['location']['latitude'] ?? 0.0,
        longitude: json['location']['longitude'] ?? 0.0,
      ),
      address: Address(
        street: json['address']['street'] ?? '',
        city: json['address']['city'] ?? '',
        parish: json['address']['parish'] ?? '',
        zone: json['address']['zone'] ?? '',
      ),
    );
  }

  static fromMenuJson(Map<String, dynamic> json) {
    return Menu(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        desplayImgUrl: json['image_url'],
        items: json['items'] != null
            ? json['items']
                .map<MenuItem>((item) => MenuItem(
                    name: item['name'],
                    imageUrls: item['image_urls'].cast<String>(),
                    description: item['description'],
                    unitPrice: item['unit_price']))
                .toList()
            : []);
  }
}
