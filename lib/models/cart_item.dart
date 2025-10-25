// models/cart_item.dart - تأكد من وجوده
import 'package:equatable/equatable.dart';
import 'grocery_item.dart';

class CartItem extends Equatable {
  final GroceryItem item;
  final int quantity;

  const CartItem({
    required this.item,
    this.quantity = 1,
  });

  CartItem copyWith({
    GroceryItem? item,
    int? quantity,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [item, quantity];
}