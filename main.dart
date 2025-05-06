import 'package:flutter/material.dart';
import 'login_page.dart';
import 'product_list_page.dart';
import 'shopping_cart_page.dart';
import 'orders_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KawaiiApp',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/products': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          return ProductListPage(
            cartId: args["cartId"] as int,
            cookies: args["cookies"] as Map<String, dynamic>,
          );
        },
        '/cart': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          return ShoppingCartPage(
            cartId: args["cartId"] as int,
            cookies: args["cookies"] as Map<String, dynamic>,
          );
        },
        '/orders': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          return OrdersPage(
            cartId: args["cartId"] as int,
            cookies: args["cookies"] as Map<String, dynamic>,
          );
        },
      },
    );
  }
}
