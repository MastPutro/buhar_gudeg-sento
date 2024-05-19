import 'dart:convert';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:buhar_gudeg/Order/AddOrder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buhar_gudeg/homepage.dart';
import 'package:intl/intl.dart';

class ItemOrder {
  final int id;
  final int id_makanan;
  final String meja;
  final int quantity;

  ItemOrder({required this.id, required this.id_makanan, required this.meja, required this.quantity});

  factory ItemOrder.fromJson(Map<String, dynamic> json) {
    return ItemOrder(id: json['id'], id_makanan: json['id_makanan'], meja: json['meja'], quantity: json['quantity']);
  }
}

class MejaDetail extends StatefulWidget {
  final int id;
  final String no_meja;

  MejaDetail({required this.id, required this.no_meja});

  @override
  State<MejaDetail> createState() => _MejaDetailState();
}

class _MejaDetailState extends State<MejaDetail> {
  List<ItemOrder> itemOrder = [];
  Map<int, String> makananNames = {};
  Map<int, int> makananPrices = {};
  double totalAmount = 0.0;
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  void _printReceipt() {
    bluetooth.printCustom("Struk Pembayaran", 1, 1);
    bluetooth.printNewLine();
    for (var order in itemOrder) {
      final itemName = makananNames[order.id_makanan] ?? 'Loading...';
      final itemPrice = makananPrices[order.id_makanan] ?? 0;
      final itemTotal = itemPrice * order.quantity;
      bluetooth.printCustom("$itemName: $itemTotal IDR", 0, 0);
      bluetooth.printCustom("Jumlah: ${order.quantity}", 0, 0);
      bluetooth.printNewLine();
    }
    bluetooth.printNewLine();
    bluetooth.printCustom("Total: $totalAmount IDR", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom("Terima Kasih!", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    runApp(MyApp());
  }

  Future<void> _addHistory() async {
    List<Map<String, dynamic>> listOrder = itemOrder.map((order) {
      return {
        "id_makan": order.id_makanan,
        "makanan": makananNames[order.id_makanan],
        "quantity": order.quantity
      };
    }).toList();

    var request = http.Request(
      'POST',
      Uri.parse('https://depotbuhar.com/api/history/store?no_meja=${widget.no_meja}&total_harga=${totalAmount.toInt()}&list_order=$listOrder'),
    );
    request.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      _printReceipt();
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _deleteByMeja() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('DELETE', Uri.parse('https://depotbuhar.com/api/order/delete-by-meja'));
    request.bodyFields = {
      'meja': widget.no_meja
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      await _addHistory();
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> fetchItem() async {
    final response = await http.get(Uri.parse('https://depotbuhar.com/api/orders/peh?meja=${widget.no_meja}'));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        itemOrder = list.map((model) => ItemOrder.fromJson(model)).toList();
        fetchMakananDetails();
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> fetchMakananDetails() async {
    double newTotalAmount = 0.0;
    for (var order in itemOrder) {
      final response = await http.get(Uri.parse('https://depotbuhar.com/api/menu/${order.id_makanan}'));
      if (response.statusCode == 200) {
        final makananData = json.decode(response.body);
        setState(() {
          makananNames[order.id_makanan] = makananData['title'];
          makananPrices[order.id_makanan] = makananData['price'];
          newTotalAmount += makananData['price'] * order.quantity;
        });
      } else {
        throw Exception('Failed to load food details');
      }
    }
    setState(() {
      totalAmount = newTotalAmount;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            // Action when floating button is pressed
            runApp(AddOrder(idmeja: widget.id, meja: widget.no_meja));
          },
          child: Text('+', style: TextStyle(color: Colors.white, fontSize: 40),),
        ),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              runApp(MyApp());
            },
          ),
          title: GestureDetector(
            onTap: (){
              fetchItem();
            },
            child: Text('Meja ${widget.no_meja}', style: GoogleFonts.inter(
              color: Colors.white
            )),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: itemOrder.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffa2e3fb),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    title: Text(
                        makananNames[itemOrder[index].id_makanan] ?? 'Loading...'
                    ),
                    subtitle: Text(
                        'Harga: ${(makananPrices[itemOrder[index].id_makanan] ?? 0) * itemOrder[index].quantity} IDR'
                    ),
                    trailing: Text('Jumlah: ${itemOrder[index].quantity}'),
                    leading: IconButton(onPressed: () async {
                      var request = http.Request('DELETE', Uri.parse('https://depotbuhar.com/api/order/sentolop/${itemOrder[index].id}'));
                      http.StreamedResponse response = await request.send();
                      if (response.statusCode == 200) {
                        print(await response.stream.bytesToString());
                        fetchItem();
                      }
                      else {
                      print(response.reasonPhrase);
                      }
                    }, icon: Icon(Icons.delete, color: Colors.red,)),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 113,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Total Amount: $totalAmount IDR',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(onPressed: (){
                _deleteByMeja();
              }, child: Text('Print Struk'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
