import 'package:flutter_application_2/Shopping/models/Item.dart';

class CartItem extends Item {
  int quantity;
  late int amount;

  CartItem({
    required this.quantity,
    required name,
    imagePath,
    price,
    rating,
    description,
  }) : super(
          name: name,
          price: price,
          rating: rating,
          description: description,
        ) {
    amount = quantity * int.parse(super.price);
  }

  int get _quantity => _quantity;
  int get _amount => _amount;
}
