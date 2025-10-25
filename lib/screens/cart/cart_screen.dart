// cart_screen.dart - النسخة المصححة
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../common_widgets/app_button.dart';
import '../../helpers/column_with_seprator.dart'; // ✅ تأكد من الاستيراد الصحيح
import '../../widgets/chart_item_widget.dart';
import 'checkout_bottom_sheet.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_state.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { // ✅ context معرف هنا
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            // معالجة تغييرات الحالة
            if (state is CartError) {
              _showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            return _buildContentBasedOnState(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildContentBasedOnState(BuildContext context, CartState state) { // ✅ إضافة context كبارامتر
    switch (state.runtimeType) {
      case CartInitial:
        return _buildInitialState(context);
      case CartLoading:
        return _buildLoadingState(context);
      case CartEmpty:
        return _buildEmptyCart(context);
      case CartLoaded:
        return _buildCartContent(context, state as CartLoaded);
      case CartError:
        return _buildErrorState(context, state as CartError);
      default:
        return _buildInitialState(context);
    }
  }

  Widget _buildInitialState(BuildContext context) { // ✅ إضافة context
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Loading cart..."),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) { // ✅ إضافة context
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(height: 16),
          Text(
            "Updating cart...",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CartError state) { // ✅ إضافة context
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            state.message,
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          AppButton(
            label: "Try Again",
            onPressed: () {
              context.read<CartBloc>().add(CartStarted()); // ✅ context متاح الآن
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    final cartItems = state.cartItems;

    if (cartItems.isEmpty) {
      return _buildEmptyCart(context);
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Cart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "${cartItems.length} ${cartItems.length == 1 ? 'item' : 'items'}",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Cart Items
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildCartItems(cartItems, context),
                SizedBox(height: 20),
                _buildCheckoutSection(context, state.totalPrice),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItems(List<CartItem> cartItems, BuildContext context) {
    return Column(
      children: getChildrenWithSeperator( // ✅ التصحيح: getChildrenWithSeperator (بدون p)
        addToLastChild: false,
        widgets: cartItems.map((cartItem) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            width: double.maxFinite,
            child: ChartItemWidget(
              cartItem: cartItem,
              onIncrease: () {
                context.read<CartBloc>().add(CartItemQuantityIncreased(cartItem.item));
              },
              onDecrease: () {
                context.read<CartBloc>().add(CartItemQuantityDecreased(cartItem.item));
              },
              onRemove: () {
                _showRemoveConfirmation(context, cartItem);
              },
            ),
          );
        }).toList(),
        seperator: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Divider(thickness: 1),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, double totalPrice) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          _buildTotalPriceRow(totalPrice),
          SizedBox(height: 20),
          _buildCheckoutButton(context, totalPrice),
        ],
      ),
    );
  }

  Widget _buildTotalPriceRow(double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Price",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "\$${totalPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, double totalPrice) {
    return AppButton(
      label: "Go To Check Out",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 30),
      trailingWidget: _buildButtonPriceWidget(totalPrice),
      onPressed: () {
        _showBottomSheet(context, totalPrice);
      },
    );
  }

  Widget _buildButtonPriceWidget(double totalPrice) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xff489E67),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "\$${totalPrice.toStringAsFixed(2)}",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
        SizedBox(height: 20),
        Text(
          "Your cart is empty",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        Text(
          "Add some products to get started",
          style: TextStyle(fontSize: 16, color: Colors.grey[500]),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: AppButton(
            label: "Start Shopping",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  void _showRemoveConfirmation(BuildContext context, CartItem cartItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remove Item"),
        content: Text("Are you sure you want to remove ${cartItem.item.name} from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartBloc>().add(CartItemRemoved(cartItem.item));
            },
            child: Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, double totalPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return CheckoutBottomSheet(totalPrice: totalPrice);
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}