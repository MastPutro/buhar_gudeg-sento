import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:buhar_gudeg/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  String? _message;

  @override
  void initState() {
    _requestPermissions();
    super.initState();
  }
  Future<void> _requestPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
    _getDevices();
  }

  Future<void> _getDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (e) {
      setState(() {
        _message = 'Error getting devices: $e';
      });
    }
    setState(() {
      _devices = devices;
    });

  }

  void _connect() {
    if (_selectedDevice != null) {
      setState(() {
        _message = 'Connected';
      });
      bluetooth.connect(_selectedDevice!).catchError((error) {
        setState(() {
          _message = 'Error connecting to device: $error';
        });
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() {
      _message = 'Disconnected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 1, child: Scaffold(
      appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('Setting',
          style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Printer Option', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<BluetoothDevice>(
                items: _devices
                    .map((device) => DropdownMenuItem(
                  child: Text(device.name!),
                  value: device,
                ))
                    .toList(),
                onChanged: (device) {
                  setState(() {
                    _selectedDevice = device;
                  });
                },
                value: _selectedDevice,
                hint: Text('Select Device'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _connect,
                child: Text('Connect'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _disconnect,
                child: Text('Disconnect'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(onPressed: (){
                print("logout");
                runApp(Main());
                Provider.of<Auth>(context, listen: false).logout();
              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  Text('Logout')
                ],
              ),style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
                  foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),),
            ),
            if (_message != null) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_message!),
            ),
          ],
        ),
      ),
    ));
  }
}
