import 'package:skibble/models/cart.dart';
import 'package:skibble/models/cart_item.dart';
import 'package:skibble/models/restaurant.dart';
import 'package:flutter/material.dart';


class CartData extends ChangeNotifier {
  Cart userCart = Cart(
    cartItems: {},
  );

  void updateUserCart(Cart cart) {
    userCart = cart;
    notifyListeners();
  }

  void addItemsToUserCart(CartItem cartItem, Restaurant restaurant) {
    if(userCart.cartItems.isEmpty) {
      userCart.cartItems.add(cartItem);
      userCart.totalItems += cartItem.amountInCart;
      userCart.cartTotalCost += cartItem.itemsTotalCost;
      userCart.restaurant = restaurant;
    }
    else {
      if(userCart.restaurant!.restaurantId == restaurant.restaurantId) {
        userCart.cartItems.add(cartItem);
        userCart.totalItems += cartItem.amountInCart;
        userCart.cartTotalCost += cartItem.itemsTotalCost;
      }

      //delete items if the new item added is not from the same restaurant
      else {
        userCart.cartItems = {};
        userCart.cartItems.add(cartItem);
        userCart.totalItems += cartItem.amountInCart;
        userCart.cartTotalCost += cartItem.itemsTotalCost;
        userCart.restaurant = restaurant;
      }
    }

    userCart.cartTotalCost = double.parse(userCart.cartTotalCost.toStringAsFixed(2));

    notifyListeners();
  }

  // void deleteItemFromUserCart(MenuItem menuItem) {
  //   userCart.cartItems.remove(menuItem);
  //   notifyListeners();
  // }

  // void updateCartItemNumberOfItems(int index, num value) {
  //   userCart.cartItems.elementAt(index).amountInCart = value;
  //
  //   userCart.cartItems.elementAt(index).itemsTotal += (userCart.cartItems.elementAt(index).amountInCart * userCart.cartItems.elementAt(index).menuItem.cost!).toDouble();
  //
  //   // userCart.cartItems.
  //   notifyListeners();
  // }
}