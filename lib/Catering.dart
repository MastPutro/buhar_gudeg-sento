import 'dart:convert';

import 'package:buhar_gudeg/Meja/CateringDetail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Catering extends StatefulWidget {
  const Catering({super.key});

  @override
  State<Catering> createState() => _CateringState();
}

class _CateringState extends State<Catering> {
  List<Map<String, dynamic>> cateringData = [];

  Future<void> fetchCatering() async {
    var request = http.Request('GET', Uri.parse('http://192.168.1.3:8000/api/ordercat'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> jsonData = json.decode(responseBody);

      setState(() {
        cateringData = jsonData.map((item) {
          return {
            "id": item["id"],
            "foodname": item["foodname"],
            "price": item["price"],
            "quantity": item["quantity"],
            "name": item["name"],
            "phone": item["phone"],
            "address": item["address"]
          };
        }).toList();
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCatering();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cateringData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                runApp(Cateringdetail(id: cateringData[index]["id"],
                    foodname: cateringData[index]["foodname"],
                    price: cateringData[index]["price"],
                    quantity: cateringData[index]["quantity"],
                    name: cateringData[index]["name"],
                    phone: cateringData[index]["phone"],
                    address: cateringData[index]["address"]));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffccf4f7),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  title: Text("Nama: ${cateringData[index]["name"]}"),
                  subtitle: Text("Total harga: ${cateringData[index]["price"]}"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
