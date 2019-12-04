import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/home_page.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/overview_page.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/seccion_inferior.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/seccion_superior.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/credit_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<Customer> customers = List();
  String error = "";

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  @override
  void dispose() {
    super.dispose();
    customers = List();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> images = List();
    for (Customer cust in customers) {
      images.add(Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(cust.fotoAsset),
              radius: 56,
            ),
            Column(children: <Widget>[
              Text(
                cust.name,
                style: TextStyle(
                    //inherit: true,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              Text(
                cust.last_name,
                style: TextStyle(
                    //inherit: true,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ])
          ]));
    }

    return MaterialApp(
      title: "Diners Club",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Diners Club - Arquitectura " + this.error),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          color: Color(0xff3e5f8a),
          child: GridView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) => GestureDetector(
                onTap: () => tapFaceLogin(index), child: images[index]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 20,
            ),
          ),
        ),
      ),
    );
  }

  void loadCustomers() {
    getCustomers().then((listCustomers) {
      for (Customer customer in listCustomers) {
        setState(() {
          customers.add(customer);
        });
      }
    }).catchError((error) {
      setState(() {
        this.error = error.toString();
      });
    });
  }

  tapFaceLogin(int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage(customers[index])));
  }
}
