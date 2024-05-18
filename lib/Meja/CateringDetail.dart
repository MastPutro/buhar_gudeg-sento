import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:buhar_gudeg/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Cateringdetail extends StatefulWidget {
  final int id;
  final String foodname;
  final String price;
  final String quantity;
  final String name;
  final String phone;
  final String address;
  
  const Cateringdetail({super.key, required this.id, required this.foodname, required this.price, required this.quantity, required this.name, required this.phone, required this.address});

  @override
  State<Cateringdetail> createState() => _CateringdetailState();
}

class _CateringdetailState extends State<Cateringdetail> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> _sendHistory()async {
    var request = http.Request('POST', Uri.parse('http://192.168.1.3:8000/api/histori/store?name=${widget.name}&phone=${widget.phone}&foodname=${widget.foodname}&quantity=${widget.quantity}&total_price=${widget.price}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      printReceipt();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void>_deleteCatering()async {
    var request = http.Request('DELETE', Uri.parse('http://192.168.1.3:8000/api/ordercat/delet/${widget.id}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      _sendHistory();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  void printReceipt() {
    bluetooth.printNewLine();
    bluetooth.printCustom("Struk Catering", 3, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom("Catering ID: ${widget.id}", 1, 0);
    bluetooth.printCustom("Nomor Telp: ${widget.phone}", 1, 0);
    bluetooth.printCustom("Nama: ${widget.name}", 1, 0);
    bluetooth.printCustom("Makanan: ${widget.foodname}", 1, 0);
    bluetooth.printCustom("Total Harga: ${widget.price}", 1, 0);
    bluetooth.printCustom("Alamat: ${widget.address}", 1, 0);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    runApp(MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            runApp(MyApp());
          }, icon: Icon(Icons.arrow_back),
          ),
          title: Text(widget.name),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(onPressed: () {
            _deleteCatering();
          }, child: Text('Print Struk'),
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue), foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Catering ID: ${widget.id}', style: GoogleFonts.inter(fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Nomor Telp: ${widget.phone}', style: GoogleFonts.inter(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Nama: ${widget.name}', style: GoogleFonts.inter(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Makanan: ${widget.foodname}', style: GoogleFonts.inter(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total Harga: ${widget.price}', style: GoogleFonts.inter(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Alamat: ${widget.address}', style: GoogleFonts.inter(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
