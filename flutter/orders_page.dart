import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {
  final int cartId;
  final Map<String, dynamic> cookies;
  const OrdersPage({super.key, required this.cartId, required this.cookies});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];
  Map <int, List<dynamic>> orderDetails = {};
  int cartId = -1;
  int _selectedIndex = 2;
  Map<String, dynamic> cookies = {};
  Set<int> expandedOrders = {};

  @override
  void initState() {
    super.initState();
    cartId = widget.cartId;
    cookies = widget.cookies;
    loadOrders();
  }

  Future<void> loadOrders() async {
    final response = await http.get(
      Uri.parse("http://localhost/kawaiifood/orders.php?user_id=${widget.cookies['user_id']}"),
    );
    if (response.statusCode == 200) {
      setState(() {
        orders = jsonDecode(response.body);
      });
    }
  }
  
  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/cart', arguments: {"cartId": widget.cartId, "cookies": widget.cookies});
    } else if (index == 0){
      Navigator.pushReplacementNamed(context, '/products', arguments: {"cartId": widget.cartId, "cookies": widget.cookies},
);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> showMore(int orderId) async {

    if (orderDetails.containsKey(orderId)) {
      setState(() {
        expandedOrders.add(orderId);
      });
      return;
    }

    final response = await http.get(
      Uri.parse("http://localhost/kawaiifood/ordersrow.php?orderr=${orderId}"),
    );
    if (response.statusCode == 200) {
      setState(() {
        orderDetails[orderId] = jsonDecode(response.body);
        expandedOrders.add(orderId);
      });
    }
  }

  void hideMore(int orderId) {
    setState(() {
      expandedOrders.remove(orderId);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elenco Ordini di ${widget.cookies['username']}'),
      ),

      body: orders.isEmpty
          ? const Center(child: Text("Nessun ordine trovato."))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderId = int.parse(order['id']);
                final isExpanded = expandedOrders.contains(orderId);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("ID Ordine: ${order['id']}"),
                      subtitle: Text("Data: ${order['creation']}\nTotale: ${order['total']} €"),
                      trailing: IconButton(
                        icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                        onPressed: () {
                          if (isExpanded){ 
                            hideMore(orderId);
                          } else {
                            showMore(orderId);
                          }
                        },
                      ),
                    ),


                    if (isExpanded && orderDetails.containsKey(orderId))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: orderDetails[orderId]!.map<Widget>((detail) {
                            return ListTile(
                              leading: Image.network(
                                'http://localhost/kawaiifood/food/${detail['file']}'
                                ),
                              title: Text("${detail['name']}"),
                              subtitle: Text("Quantità: ${detail['quantity']}\nPrezzo: ${detail['price']} €"),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Prodotti'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrello'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Ordini'),
        ],
      ),
    );
  }
}