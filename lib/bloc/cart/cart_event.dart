// cart_event.dart - التحديث النهائي
import 'package:equatable/equatable.dart';
import 'package:online_shop/models/grocery_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class CartStarted extends CartEvent {
  @override
  List<Object> get props => [];
}

class CartItemAdded extends CartEvent {
  final GroceryItem item;
  final int amount; // ⬅️ الإضافة الأساسية

  const CartItemAdded(this.item, this.amount); // ⬅️ التحديث

  @override
  List<Object> get props => [item, amount]; // ⬅️ التحديث
}

class CartItemRemoved extends CartEvent {
  final GroceryItem item;

  const CartItemRemoved(this.item);

  @override
  List<Object> get props => [item];
}

class CartItemQuantityIncreased extends CartEvent {
  final GroceryItem item;

  const CartItemQuantityIncreased(this.item);

  @override
  List<Object> get props => [item];
}

class CartItemQuantityDecreased extends CartEvent {
  final GroceryItem item;

  const CartItemQuantityDecreased(this.item);

  @override
  List<Object> get props => [item];
}

class CartCheckoutRequested extends CartEvent {
  @override
  List<Object> get props => [];
}