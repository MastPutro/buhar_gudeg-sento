import 'package:buhar_gudeg/Catering.dart';
import 'package:buhar_gudeg/Meja.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String appbar = 'Makan Di Tempat';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          appbar = 'Makan Di Tempat';
        });
      } else if (_tabController.index == 1) {
        setState(() {
          appbar = 'Catering';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(appbar, style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.grey,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Container(
                      constraints: BoxConstraints(minWidth: double.infinity),
                      child: Icon(Icons.store_mall_directory),
                    ),
                  ),
                  Tab(
                    icon: Container(
                      constraints: BoxConstraints(minWidth: double.infinity),
                      child: Icon(Icons.delivery_dining),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // TAB 1
                  Meja(),
                  // TAB 2
                  Catering(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
