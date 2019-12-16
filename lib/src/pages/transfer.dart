import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/models/transfer_account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert' as convert;
import 'package:toast/toast.dart';

import 'home_page.dart';

class Transfer extends StatefulWidget {
  UserModel user;
  int userId;
  Customer customer;

  Transfer(this.user, this.userId, this.customer);

  @override
  TransferState createState() => TransferState();
}

class TransferState extends State<Transfer> {
  bool _saving = false;
  Future<List<TransferAccount>> fromAccFuture;
  Future<List<TransferAccount>> toAccFuture;
  int selectedRadioFrom;
  int selectedRadioTo;
  TransferAccount selectedFromAccount;
  TransferAccount selectedToAccount;
  final textFieldController = TextEditingController();
  final textDescriptionController = TextEditingController();

  TransferState();

  @override
  void initState() {
    selectedRadioFrom = 0;
    selectedRadioTo = 0;
    selectedFromAccount = TransferAccount(number: "", brand: "", type: "");
    selectedToAccount = TransferAccount(number: "", brand: "", type: "");
    textDescriptionController.text = "";
    fromAccFuture = joinProductsTransfer(widget.userId, true);
    toAccFuture = joinProductsTransfer(widget.user.userId, false);
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    textDescriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return ModalProgressHUD(child: _page(_media), inAsyncCall: _saving);
  }

  Widget _page(Size _media) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 20,
          top: 70,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Transferir A",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ],
          ),
          Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "Desde la cuenta",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          listAccountsCards(widget.userId, true),
          SizedBox(
            height: 25,
          ),
          Text(
            "A la cuenta",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          listAccountsCards(widget.userId, false),
          TextField(
              controller: textDescriptionController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Descripción',
                  icon: Icon(Icons.description)),
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w100,
                fontSize: 12.0,
                height: 2.0,
              ),
              cursorColor: Colors.red),
          Container(
              margin: const EdgeInsets.only(right: 40, left: 100),
              child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '\$',
                      icon: Icon(Icons.attach_money)),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 60.0,
                    height: 2.0,
                  ),
                  cursorColor: Colors.red,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (monto) {
                    tranferir(monto, widget.user, widget.userId, context,
                        widget.customer, textDescriptionController.text);
                  })),
        ],
      ),
    );
  }

  Future tranferir(String monto, UserModel user, int userId,
      BuildContext context, Customer customer, String description) async {
    setState(() {
      _saving = true;
    });

    TransferAccount fromAccount = selectedFromAccount;
    TransferAccount toAccount = selectedToAccount;

    if (fromAccount.number.length > 0 && toAccount.number.length > 0) {
      var client = new http.Client();
      try {
        Map<String, String> headers = {"Content-type": "application/json"};
        String jsonBody = getJson(fromAccount.number, toAccount.number, monto, description);
        print(jsonBody);
        http.Response response = await client.post(
            'https://kvillacreses-eval-prod.apigee.net/pagos/transfers',
            headers: headers,
            body: jsonBody);
        if (response.statusCode == 200) {
          Map<String, dynamic> body = convert.jsonDecode(response.body);
          print(body);
          int res = body['response']['code'];
          if (res == 0) {
            Navigator.pop(context, "transfer");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage(customer)));
          } else {
            Toast.show("Error Enviando Transferencia", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          }
          setState(() {
            _saving = false;
          });
        } else {
          throw "Error ejecutando transferencia";
        }
      } finally {
        client.close();
      }
    } else {
      Toast.show("Cuentas no seleccionadas", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        _saving = false;
      });
    }
  }

  String getJson(
      String fromAccount, String toAccount, String monto, String description) {
    String fromType = getType(fromAccount);
    String toType = getType(toAccount);
    String jsonBody = '''
    {"origin": "$fromAccount",
        "origin_type": "$fromType",
        "target": "$toAccount",
        "target_type": "$toType",
        "amount": "$monto",
        "type": "FOUNDS_TRANSFER",
        "description":"$description"
        }''';
    return jsonBody;
  }

  String getType(String acc) {
    if (acc.length == 6) {
      return "ACCOUNTS";
    } else {
      return "CREDIT_CARDS";
    }
  }

  Widget listAccountsCards(int userId, bool from) {
    Future future;
    if(from){
      future = fromAccFuture;
    } else {
      future = toAccFuture;
    }
    return FutureBuilder<List<TransferAccount>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Cargando....');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Widget> widgetsToLoad = List();
              if (from) {
                widgetsToLoad = radioAccountsFrom(snapshot?.data);
              } else {
                widgetsToLoad = radioAccountsTo(snapshot?.data);
              }
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start, children: widgetsToLoad);
            }
        }
      },
    );
  }

  List<Widget> radioAccountsFrom(List<TransferAccount> accounts) {
    List<Widget> widgets = [];
    for (TransferAccount acc in accounts) {
      widgets.add(RadioListTile(
        value: acc,
        groupValue: selectedFromAccount,
        title: Text(acc.number),
        subtitle: Text(acc.brand),
        onChanged: (val) {
          print("Radio $val");
          setSelectedRadioFrom(val);
        },
        selected: false,
        activeColor: Colors.blue,
      ));
    }
    return widgets;
  }

  List<Widget> radioAccountsTo(List<TransferAccount> accounts) {
    List<Widget> widgets = [];
    for (TransferAccount acc in accounts) {
      widgets.add(RadioListTile(
        value: acc,
        groupValue: selectedToAccount,
        title: Text(acc.number),
        subtitle: Text(acc.brand),
        onChanged: (val) {
          print("Radio $val");
          setSelectedRadioTo(val);
        },
        selected: false,
        activeColor: Colors.blue,
      ));
    }
    return widgets;
  }

  setSelectedRadioFrom(TransferAccount val) {
    setState(() {
      selectedFromAccount = val;
    });
  }

  setSelectedRadioTo(TransferAccount val) {
    setState(() {
      selectedToAccount = val;
    });
  }
}
