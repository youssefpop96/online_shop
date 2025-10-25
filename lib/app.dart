// app.dart - النسخة المحسنة
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/cart/cart_bloc.dart';
import 'package:online_shop/bloc/cart/cart_event.dart';
import 'package:online_shop/screens/splash_screen.dart';
import 'package:online_shop/styles/theme.dart';

import 'bloc/cart/cart_state.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc();
            // بدء تحميل السلة بعد تهيئة التطبيق
            Future.delayed(Duration(milliseconds: 100), () {
              bloc.add(CartStarted());
            });
            return bloc;
          },
          lazy: false, // ✅ تهيئة الـ Bloc فوراً
        ),
      ],
      child: MaterialApp(
        theme: themeData,
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        // إضافة معالجة للأخطاء العالمية
        builder: (context, child) {
          return BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              // معالجة تغييرات الحالة العالمية
              if (state is CartError) {
                // يمكن إضافة معالجة للأخطاء العالمية هنا
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}