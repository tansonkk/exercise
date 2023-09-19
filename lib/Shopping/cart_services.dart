import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Shopping/models/Cart_item.dart';
import 'package:flutter_application_2/Shopping/models/Item.dart';

class CartServices extends ChangeNotifier {
  List<CartItem> cartItemList = [];
  int totalAmount = 0;

  void calTotalAmount() {
    totalAmount = 0;
    for (CartItem item in cartItemList) {
      cartItemList.isNotEmpty ? totalAmount += item.amount : totalAmount = 0;
    }
    notifyListeners();
  }

  void addItemToCart(CartItem item) {
    //checking each key value pair of each cart items
    cartItemList.any((obj) => obj.name == item.name)
        ? null
        : cartItemList.add(item);
    calTotalAmount();
    notifyListeners();
  }

  CartItem findtarget(String name) {
    int index = cartItemList.indexWhere((obj) => obj.name == name);
    final target = cartItemList[index];
    return target;
  }

  void incrementItem(CartItem item) {
    CartItem target = findtarget(item.name);
    target.quantity++;
    target.amount = target.quantity * int.parse(target.price);
    calTotalAmount();
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    CartItem target = findtarget(item.name);
    target.quantity == 1 ? target.quantity = 1 : target.quantity--;
    target.amount = target.quantity * int.parse(target.price);
    calTotalAmount();
    notifyListeners();
  }

  void removeItemFromCart(CartItem item) {
    CartItem target = findtarget(item.name);
    cartItemList.remove(target);
    calTotalAmount();
    notifyListeners();
  }
}
