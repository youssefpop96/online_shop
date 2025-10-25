// cart_repository.dart - اختياري للتحسين المستقبلي
import '../../models/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> loadCart();
  Future<void> saveCart(List<CartItem> items);
  Future<void> clearCart();
}

class LocalCartRepository implements CartRepository {
  @override
  Future<List<CartItem>> loadCart() async {
    // تنفيذ تحميل السلة من التخزين المحلي
    await Future.delayed(Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<void> saveCart(List<CartItem> items) async {
    // تنفيذ حفظ السلة في التخزين المحلي
    await Future.delayed(Duration(milliseconds: 300));
  }

  @override
  Future<void> clearCart() async {
    // تنفيذ مسح السلة
    await Future.delayed(Duration(milliseconds: 200));
  }
}