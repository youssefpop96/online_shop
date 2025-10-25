import 'package:flutter/material.dart';
import '../common_widgets/app_text.dart';
import '../models/cart_item.dart';

class ChartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const ChartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              cartItem.item.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),

          // التفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: cartItem.item.name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 5),
                AppText(
                  text: cartItem.item.description,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600]!,
                ),
                Spacer(),
                Row(
                  children: [
                    // أزرار الكمية
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 20),
                            onPressed: onDecrease,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(minWidth: 45, minHeight: 45),
                          ),
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                cartItem.quantity.toString(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 20),
                            onPressed: onIncrease,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(minWidth: 45, minHeight: 45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // السعر والحذف
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  color: Colors.grey[500],
                  size: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "\$${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}