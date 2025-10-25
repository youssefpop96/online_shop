import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_text.dart';
import '../../models/grocery_item.dart';
import '../../widgets/item_counter_widget.dart';
import 'favourite_toggle_icon_widget.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';

class ProductDetailsScreen extends StatefulWidget {
  final GroceryItem groceryItem;
  final String? heroSuffix;

  const ProductDetailsScreen(this.groceryItem, {this.heroSuffix});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int amount = 1;
  double get totalAmount => widget.groceryItem.price * amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getImageHeaderWidget(),
            Expanded( // ✅ إضافة Expanded لمنع overflow
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView( // ✅ تغيير إلى ListView
                  children: [
                    SizedBox(height: 20),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        widget.groceryItem.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: AppText(
                        text: widget.groceryItem.description,
                        fontSize: 16,
                        color: Color(0xFF7C7C7C),
                        fontWeight: FontWeight.w600,
                      ),
                      trailing: FavoriteToggleIcon(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        ItemCounterWidget(
                          onAmountChanged: (newAmount) {
                            setState(() {
                              amount = newAmount;
                            });
                          },
                        ),
                        Spacer(),
                        Text(
                          "\$${totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    getDivider(),
                    getProductDataRowWidget("Product Detail"),
                    getProductDescription(),
                    SizedBox(height: 20),
                    getProductDataRowWidget("Nutritions",
                        customWidget: nutritionWidget()),
                    SizedBox(height: 20),
                    getProductDataRowWidget(
                      "Review",
                      customWidget: ratingWidget(),
                    ),
                    SizedBox(height: 30),
                    AppButton(
                      label: "Add To Basket",
                      onPressed: () {
                        context.read<CartBloc>().add(
                          CartItemAdded(
                            widget.groceryItem,
                            amount,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${widget.groceryItem.name} x$amount added to cart!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget getProductDescription() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: AppText(
        text:
        "A banana is an elongated, edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa. In some countries, bananas used for cooking may be called \"plantains\", distinguishing them from dessert bananas. The fruit is variable in size, color, and firmness, but is usually elongated and curved, with soft flesh rich in starch covered in a rind which may be green, yellow, red, purple, or brown when ripe.",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF7C7C7C),
      ),
    );
  }

  Widget getImageHeaderWidget() {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(0xFFF2F3F2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: FavoriteToggleIcon(),
          ),
          Center(
            child: Hero(
              tag: "GroceryItem:${widget.groceryItem.name}-${widget.heroSuffix ?? ""}",
              child: Image(
                image: AssetImage(widget.groceryItem.imagePath),
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getProductDataRowWidget(String label, {Widget? customWidget}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          AppText(text: label, fontWeight: FontWeight.w600, fontSize: 16),
          Spacer(),
          if (customWidget != null) ...[
            customWidget,
            SizedBox(width: 10)
          ],
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
          )
        ],
      ),
    );
  }

  Widget nutritionWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text: "100gm",
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xff7C7C7C),
      ),
    );
  }

  Widget ratingWidget() {
    Widget starIcon() {
      return Icon(
        Icons.star,
        color: Color(0xffF3603F),
        size: 18,
      );
    }

    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }
}