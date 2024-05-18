import 'dart:convert';
import 'package:buhar_gudeg/Meja/MejaDetail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ItemMeja{
  final int id;
  final String no_meja;

  ItemMeja({required this.id, required this.no_meja});
  factory ItemMeja.fromJson(Map<String, dynamic> json){
    return ItemMeja(
        id: json['id'],
        no_meja: json['no_meja']);
  }
}

class Meja extends StatefulWidget {
  const Meja({super.key});

  @override
  State<Meja> createState() => _MejaState();
}

class _MejaState extends State<Meja> {
  @override
  void initState() {
    fetchMeja();
    super.initState();
  }

  List<ItemMeja> mejas = [];

  Future<void> fetchMeja()async {
    final response = await http.get(Uri.parse('http://192.168.1.3:8000/api/meja'));
    if (response.statusCode == 200){
      setState(() {
        Iterable list = json.decode(response.body);
        mejas = list.map((model) => ItemMeja.fromJson(model)).toList();
      });
    } else{
      throw Exception('Failed to entry Meja');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(itemCount: mejas.length, itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {
              runApp(MejaDetail(id: mejas[index].id, no_meja: mejas[index].no_meja));
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffccf4f7)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Meja : ${mejas[index].no_meja}',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
