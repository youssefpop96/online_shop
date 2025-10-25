// cart_bloc.dart - النسخة المحسنة
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/cart/cart_event.dart';
import 'package:online_shop/bloc/cart/cart_state.dart';
import 'package:online_shop/models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  Timer? _debounceTimer;
  bool _isProcessing = false;

  CartBloc() : super(CartInitial()) { // ✅ بدء بـ CartInitial بدلاً من CartLoaded
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityIncreased>(_onQuantityIncreased);
    on<CartItemQuantityDecreased>(_onQuantityDecreased);
    on<CartCheckoutRequested>(_onCheckoutRequested);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _onCartStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const CartLoaded());
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    print('🛒 Adding item to cart: ${event.item.name} x${event.amount}');
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final newItems = List<CartItem>.from(currentState.cartItems);

      final existingCartItemIndex = newItems.indexWhere(
            (item) => item.item.id == event.item.id,
      );

      if (existingCartItemIndex != -1) {
        final existingItem = newItems[existingCartItemIndex];
        newItems[existingCartItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + event.amount,
        );
      } else {
        newItems.add(CartItem(item: event.item, quantity: event.amount));
      }

      emit(currentState.copyWith(cartItems: newItems));
    }
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final newItems = currentState.cartItems
          .where((cartItem) => cartItem.item.id != event.item.id)
          .toList();

      emit(currentState.copyWith(cartItems: newItems));
    }
  }

  void _onQuantityIncreased(CartItemQuantityIncreased event, Emitter<CartState> emit) {
    if (state is CartLoaded && !_isProcessing) {
      _isProcessing = true;

      // إلغاء المؤقت السابق إذا كان موجوداً
      _debounceTimer?.cancel();

      // إضافة Debounce لمنع التحديثات المتكررة
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        final currentState = state as CartLoaded;
        final newItems = List<CartItem>.from(currentState.cartItems);

        final existingCartItemIndex = newItems.indexWhere(
              (item) => item.item.id == event.item.id,
        );

        if (existingCartItemIndex != -1) {
          final existingItem = newItems[existingCartItemIndex];
          newItems[existingCartItemIndex] = existingItem.copyWith(
            quantity: existingItem.quantity + 1,
          );
          emit(currentState.copyWith(cartItems: newItems));
        }

        _isProcessing = false;
      });
    }
  }

  void _onQuantityDecreased(CartItemQuantityDecreased event, Emitter<CartState> emit) {
    if (state is CartLoaded && !_isProcessing) {
      _isProcessing = true;

      _debounceTimer?.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        final currentState = state as CartLoaded;
        final newItems = List<CartItem>.from(currentState.cartItems);

        final existingCartItemIndex = newItems.indexWhere(
              (item) => item.item.id == event.item.id,
        );

        if (existingCartItemIndex != -1) {
          final existingItem = newItems[existingCartItemIndex];
          if (existingItem.quantity > 1) {
            newItems[existingCartItemIndex] = existingItem.copyWith(
              quantity: existingItem.quantity - 1,
            );
          } else {
            newItems.removeAt(existingCartItemIndex);
          }
          emit(currentState.copyWith(cartItems: newItems));
        }

        _isProcessing = false;
      });
    }
  }

  void _onCheckoutRequested(CartCheckoutRequested event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      emit(CartLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        emit(const CartLoaded(cartItems: [], totalPrice: 0.0));
      } catch (e) {
        emit(const CartError("An error occurred during checkout."));
      }
    }
  }
}