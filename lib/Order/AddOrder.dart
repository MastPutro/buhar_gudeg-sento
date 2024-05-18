import 'package:buhar_gudeg/Meja/MejaDetail.dart';
import 'package:buhar_gudeg/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Item {
  final int id;
  final String name;
  final int price;

  Item({required this.id, required this.name, required this.price});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['title'],
      price: json['price'],
    );
  }
}

class Order {
  final Item item;
  final int quantity;

  Order({required this.item, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'item_id': item.id,
      'quantity': quantity,
    };
  }
}

class AddOrder extends StatefulWidget {
  final int idmeja;
  final String meja;

  AddOrder({super.key, required this.idmeja, required this.meja});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AddOrder> {

  List<Item> items = [];
  int totalPrice = 0;
  List<TextEditingController> counterControllers = [];

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('http://192.168.1.3:8000/api/menu'));
    if (response.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(response.body);
        items = list.map((model) => Item.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> _addOrder(int id_makanan, String meja, int quantity) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.3:8000/api/order/store'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_makanan': id_makanan,
        'meja': meja,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      print('Order added successfully');
    } else {
      print('Failed to add order ${response}');
    }
  }

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in counterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveOrder() {
    for (int i = 0; i < items.length; i++) {
      int quantity = int.tryParse(counterControllers[i].text) ?? 0;
      if (quantity > 0) {
        _addOrder(items[i].id, widget.meja, quantity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Container(
          height: 76,
          decoration: BoxDecoration(
              color: Color(0xffebebeb)
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text('Total Harga: Rp. $totalPrice'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                child: ElevatedButton(onPressed: () {
                  _saveOrder();
                  runApp(MejaDetail(id: widget.idmeja, no_meja: widget.meja));
                }, child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => runApp(MejaDetail(id: widget.idmeja, no_meja: widget.meja)),
          ),
          title: Text("Add Order", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (counterControllers.length <= index) {
              counterControllers.add(TextEditingController());
            }
            return Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffebebeb)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Text(items[index].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text('Rp. ${items[index].price}', style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              int currentCounter = int.tryParse(counterControllers[index].text) ?? 0;
                              if (currentCounter > 0) {
                                currentCounter--;
                                counterControllers[index].text = currentCounter.toString();
                                totalPrice -= items[index].price;
                              }
                            });
                          },
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: counterControllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                int counter = value.isEmpty ? 0 : int.parse(value);
                                totalPrice += (counter * items[index].price);
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              int currentCounter = int.tryParse(counterControllers[index].text) ?? 0;
                              currentCounter++;
                              counterControllers[index].text = currentCounter.toString();
                              totalPrice += items[index].price;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

