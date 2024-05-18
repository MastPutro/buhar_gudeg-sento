import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderHistory {
  final int id;
  final String noMeja;
  final int totalHarga;
  final String listOrder;

  OrderHistory({required this.id, required this.noMeja, required this.totalHarga, required this.listOrder});

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      id: json['id'],
      noMeja: json['no_meja'],
      totalHarga: json['total_harga'],
      listOrder: json['list_order'],
    );
  }
}

class EatHere extends StatefulWidget {
  const EatHere({super.key});

  @override
  State<EatHere> createState() => _EatHereState();
}

class _EatHereState extends State<EatHere> {
  List<OrderHistory> _orderHistoryList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    final response = await http.get(Uri.parse('http://192.168.1.3:8000/api/history'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _orderHistoryList = jsonData.map((item) => OrderHistory.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load order history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _orderHistoryList.length,
        itemBuilder: (context, index) {
          final orderHistory = _orderHistoryList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff98e5ff),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                title: Text('ID: ${orderHistory.id}'),
                subtitle: Text('No Meja: ${orderHistory.noMeja}\nTotal Harga: ${orderHistory.totalHarga} IDR'),
              ),
            ),
          );
        },
      ),
    );
  }
}
