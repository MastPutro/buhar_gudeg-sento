import 'dart:io';

import 'package:buhar_gudeg/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();
  final Uri _url = Uri.parse('https://depotbuhar.com/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }


  @override
  void dispose(){
    super.dispose();
    _password.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  launchUrl(
                    Uri.parse('https://depotbuhar.com/'),
                    mode: LaunchMode.externalApplication,
                  );
                });
              },
              child: Text('depotbuhar.com', style: GoogleFonts.inter(
                fontSize: 17,
                color: Colors.blue,
                decoration: TextDecoration.underline
              ),),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xff70d9ff),
                      Color(0xff1096fb),
                      Color(0xff1cc1fd)
                    ])
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Image.asset('images/ico.png'),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Align(
                    alignment: AlignmentDirectional(0, 1),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text('Login', style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50
                                )
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 16
                                  )
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pelase enter password!';
                                }
                                return null;
                              },
                              obscureText: true,
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 16
                                  )
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                              ), onPressed: () {
                              Map creds = {
                                'email' : _email.text,
                                'password' : _password.text,
                                'device_name' : 'mobile',
                              };
                              if (_formKey.currentState != null && _formKey.currentState!.validate()){
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                auth.login(creds: creds);
                              }
                            }, child: Text('Login', style: GoogleFonts.inter( fontSize: 20),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
