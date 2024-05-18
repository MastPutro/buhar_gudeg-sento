import 'package:buhar_gudeg/History/CateringHistory.dart';
import 'package:buhar_gudeg/History/EatHere.dart';
import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue
            ),
            child: TabBar(
                tabs: [
              Tab(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: double.infinity,
                    minWidth: double.infinity
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text('Catering'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: double.infinity,
                      minWidth: double.infinity
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text('Makan di Tempat'),
                  ),
                ),
              ),
            ],
              indicator: BoxDecoration(
                color: Color(0xff3092f3),
                borderRadius: BorderRadius.circular(20),
              ),
              labelColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Expanded(
            child: TabBarView(children: [
              //                                                                  TAB KATERING
              Container(
                child: Cateringhistory(),
              ),
              Container(
                child: EatHere(),
              ),
            ]),
          )
        ],
      ),
    ));
  }
}
