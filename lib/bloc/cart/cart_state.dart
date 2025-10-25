// cart_state.dart - النسخة المحسنة
import 'package:equatable/equatable.dart';
import 'package:online_shop/models/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;

  const CartLoaded({this.cartItems = const [], this.totalPrice = 0.0});

  static double calculateTotalPrice(List<CartItem> items) {
    return items.fold(0.0, (sum, current) => sum + (current.item.price * current.quantity));
  }

  CartLoaded copyWith({List<CartItem>? cartItems, double? totalPrice}) {
    final newItems = cartItems ?? this.cartItems;
    return CartLoaded(
      cartItems: newItems,
      totalPrice: totalPrice ?? calculateTotalPrice(newItems),
    );
  }

  bool get isEmpty => cartItems.isEmpty;
  bool get isNotEmpty => cartItems.isNotEmpty;

  @override
  List<Object> get props => [cartItems, totalPrice];
}

class CartEmpty extends CartState {
  @override
  List<Object> get props => [];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}