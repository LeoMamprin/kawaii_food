import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListPage extends StatefulWidget {
  final int cartId;
  final Map<String, dynamic> cookies;
  const ProductListPage({super.key, required this.cartId, required this.cookies});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> products = [];
  int _selectedIndex = 0;

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse("http://localhost/kawaiifood/products.php"),
    );
    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
      });
    }
  }

  Future<void> addToCart(int productId) async {
    final response = await http.put(
      Uri.parse("http://localhost/kawaiifood/shoppingbagrow.php"),
      body: {
        "shoppingbag": widget.cartId.toString(),
        "product": productId.toString(),
        "user": widget.cookies["user_id"],
      },
    );
    if (jsonDecode(response.body)["code"] == 1){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Prodotto aggiunto al carrello")),
      );
      getMoney();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Denaro insufficiente")),
      );
    }
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





  @override
  void initState() {
    super.initState();
    fetchProducts();
    getMoney();
  }

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/cart',  arguments: {"cartId": widget.cartId, "cookies": widget.cookies},);
    } else if (index == 2){
      Navigator.pushReplacementNamed(context, '/orders', arguments: {"cartId": widget.cartId, "cookies": widget.cookies});
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Elenco Prodotti'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Benvenuto ${widget.cookies['username']}', style: TextStyle(fontSize: 12)),
                Text('Saldo disponibile: ${widget.cookies['money']} €', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              'http://localhost/kawaiifood/food/${products[index]['image']}',
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.fastfood),
            ),
            title: Text(products[index]['name']),
            subtitle: Text("Prezzo: ${products[index]['price']} €"),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => addToCart(int.parse(products[index]['id'])),
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
