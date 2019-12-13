import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<Customer> customers = List();
  Future<List<Customer>> future;
  String error = "";

  @override
  void initState() {
    future = getCustomers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    customers = List();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Customer>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return application(Text('Loading....'));
          default:
            if (snapshot.hasError) {
              return application(Text('Error: ${snapshot.error}'));
            } else {
              return application(Container(
                  margin: EdgeInsets.only(top: 30),
                  child: loadCustomers(snapshot)));
            }
        }
      },
    );
  }

  Widget application(Widget content) {
    return MaterialApp(
      title: "Diners Club",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Diners Club - Arquitectura "),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF095c80), Colors.white],
                stops: [0.00001, 0.50, 1.2],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight
              )
            ),
            child: content),
      ),
    );
  }

  Widget loadCustomers(AsyncSnapshot snapshot) {
    List<Widget> images = List();

    for (Customer cust in snapshot?.data) {
      images.add(buildCustomers(cust));
      customers.add(cust);
    }
    return facesTableCustomers(images);
  }

  Column buildCustomers(Customer cust) {
    return Column(
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
        ]);
  }

  tapFaceLogin(int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage(customers[index])));
  }

  Widget facesTableCustomers(List<Widget> images) {
    return GridView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) => GestureDetector(
          onTap: () => tapFaceLogin(index), child: images[index]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 40,
        crossAxisSpacing: 20,
      ),
    );
  }
}
