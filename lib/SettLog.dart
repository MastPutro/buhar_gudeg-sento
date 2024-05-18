import 'package:buhar_gudeg/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ConnectPrinterScreen extends StatefulWidget {
  @override
  _ConnectPrinterScreenState createState() => _ConnectPrinterScreenState();
}

class _ConnectPrinterScreenState extends State<ConnectPrinterScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  String? _message;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Align(
          alignment: Alignment.center,
          child: Text('Setting',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Provider.of<Auth>(context, listen: false).logout();
              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  Text('Logout')
                ],
              ),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
                    foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)
                ),),
            ),
            if (_message != null) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_message!),
            ),
          ],
        ),
      ),
    );
  }
}