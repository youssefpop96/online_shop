import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:online_shop/screens/product_details/product_details_screen.dart';
import '../common_widgets/app_text.dart';
import '../models/grocery_item.dart';
import '../widgets/grocery_item_card_widget.dart';
import 'filter_screen.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String categoryName; // ⬅️ إضافة parameter

  const CategoryItemsScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.sort,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: AppText(
            text: categoryName, // ⬅️ استخدام الـ parameter
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          children: _getCategoryProducts().asMap().entries.map<Widget>((e) {
            GroceryItem groceryItem = e.value;
            return GestureDetector(
              onTap: () {
                onItemClicked(context, groceryItem);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: GroceryItemCardWidget(
                  item: groceryItem,
                  heroSuffix: "explore_screen",
                ),
              ),
            );
          }).toList(),
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 0.0,
        ),
      ),
    );
  }

  List<GroceryItem> _getCategoryProducts() {
    // إرجاع المنتجات بناءً على التصنيف
    switch (categoryName) {
      case "Beverages":
        return beverages;
      case "Fresh Fruits & Vegetables":
        return demoItems.where((item) =>
        item.name.contains("Apple") ||
            item.name.contains("Banana") ||
            item.name.contains("Pepper")
        ).toList();
      case "Meat & Fish":
        return demoItems.where((item) =>
        item.name.contains("Meat") ||
            item.name.contains("Chicken")
        ).toList();
      default:
        return demoItems + beverages; // جميع المنتجات
    }
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          groceryItem,
          heroSuffix: "explore_screen",
        ),
      ),
    );
  }
}