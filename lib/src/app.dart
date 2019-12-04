import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/home_page.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Varela",
      ),
      home: LoginPage(),
      //home: HomePage(Customer(email: "",id: "4",last_name:"",name: "",fotoAsset:"")),
    );
  }
}
