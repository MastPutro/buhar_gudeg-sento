import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CateringHistory {
  final int id;
  final String name;
  final String foodname;
  final int price;
  final int quantity;
  final String phone;

  CateringHistory({
    required this.id,
    required this.foodname,
    required this.price,
    required this.quantity,
    required this.name,
    required this.phone,
  });

  factory CateringHistory.fromJson(Map<String, dynamic> json) {
    return CateringHistory(
      id: json['id'],
      foodname: json['foodname'],
      price: json['total_price'],
      quantity: json['quantity'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class Cateringhistory extends StatefulWidget {
  const Cateringhistory({super.key});

  @override
  State<Cateringhistory> createState() => _CateringhistoryState();
}

class _CateringhistoryState extends State<Cateringhistory> {
  List<CateringHistory> _cateringHistoryList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCatering();
  }

  Future<void> fetchCatering() async {
    final response = await http.get(Uri.parse('https://depotbuhar.com/api/histori'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _cateringHistoryList = jsonData.map((item) => CateringHistory.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load order history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cateringHistoryList.length,
        itemBuilder: (context, index) {
          final history = _cateringHistoryList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff98e5ff),
                borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                title: Text('ID : ${history.id.toString()}'),
                subtitle: Text('Nama : ${history.name}'),
                trailing: Column(
                  children: [
                    Text(history.foodname),
                    Text('Jumlah : ${history.quantity}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
