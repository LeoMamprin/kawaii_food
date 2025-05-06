import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShoppingCartPage extends StatefulWidget {
  final int cartId;
  final Map<String, dynamic> cookies;
  const ShoppingCartPage({super.key, required this.cartId, required this.cookies});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<dynamic> items = [];
  int cartId = -1;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    cartId = widget.cartId;
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final response = await http.get(
      Uri.parse("http://localhost/kawaiifood/shoppingbag.php?cart_id=${widget.cartId}"),
    );
    if (response.statusCode == 200) {
      setState(() {
        items = jsonDecode(response.body);
      });
    }
    getMoney();
  }

   Future<void> getMoney() async {
    final response = await http.get(
      Uri.parse("http://localhost/kawaiifood/getMoney.php?user_id=${widget.cookies['user_id']}"),
    );

    if (response.statusCode == 200) {
      setState(() {
        widget.cookies['money'] = jsonDecode(response.body)["money"];
      });
    }
  }

  Future<void> removeFromCart(int productId) async {
    await http.delete(
      Uri.parse("http://localhost/kawaiifood/shoppingbagrow.php"),
      body: {
        "shoppingbag": widget.cartId.toString(),
        "product": productId.toString(),
        "user": widget.cookies["user_id"],
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Prodotto rimosso dal carrello")),
    );
    loadCartItems();
  }

   Future<void> deleteAllItems() async {
    await http.delete(
      Uri.parse("http://localhost/kawaiifood/shoppingbag.php?cart_id=${widget.cartId}"),
      body: {
        "shoppingbag": widget.cartId.toString(),
        "user": widget.cookies["user_id"],
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Carrello svuotato")),
    );
    loadCartItems();
  }

  Future<void> sendCartAsOrder() async {
    final response = await http.put(
      Uri.parse("http://localhost/kawaiifood/ordersrow.php"),
      body: {
        "shoppingbag": widget.cartId.toString(),
        "user": widget.cookies["user_id"],
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        items = [];
        cartId = -1;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ordine inviato con successo!")),);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Errore durante l'invio dell'ordine.")),
      );
    }

    await http.put(
      Uri.parse("http://localhost/kawaiifood/shoppingbag.php"),
      body: {
        "shoppingbag": ((widget.cartId)+1).toString(),
        "user": widget.cookies["user_id"],
      },
    );
    setState(() {
        cartId = widget.cartId + 1;
      });
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/products', arguments: {"cartId": cartId, "cookies": widget.cookies});
    } else if (index == 2){
      Navigator.pushReplacementNamed(context, '/orders', arguments: {"cartId": cartId, "cookies": widget.cookies});
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Carrello di ${widget.cookies['username']}'),
            Text('Saldo disponibile: ${widget.cookies['money']} €', style: TextStyle(fontSize: 12)),
          ],
        ),



        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteAllItems,
            tooltip: 'Elimina tutti gli articoli',
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendCartAsOrder,
            tooltip: 'Invia ordine',
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text("Il carrello è vuoto."))
          : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(
                  'http://localhost/kawaiifood/food/${item['file']}',
                ),
                title: Text(item['name']),
                subtitle: Text(
                  "Quantità: ${item['quantity']}\nPrezzo: ${item['price']} €",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => removeFromCart(int.parse(item['id'])),
                ),
              );
            },
          ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Prodotti',),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrello',),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Ordini',),
        ],
      ),
    );
  }
}
