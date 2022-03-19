import 'package:cubit/cubit.dart';
import 'package:food/models/header.dart';

class HeaderCubit extends Cubit<Header> {
  HeaderCubit() : super(Header('', ''));

  update(String title, String imageUrl) => emit(Header(title, imageUrl));
}
