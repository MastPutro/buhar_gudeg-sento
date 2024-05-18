
import 'package:buhar_gudeg/Login.dart';
import 'package:buhar_gudeg/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

void main() {
  runApp(Main());
}


class Main extends StatelessWidget {

  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<Auth>(
          builder: (context, auth, _) {
            return auth.authenticated ? MyApp() : Login();
          },
        ),
      ),
    );
  }
}


