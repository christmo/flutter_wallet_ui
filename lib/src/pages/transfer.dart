import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/models/user_model.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert' as convert;
import 'package:toast/toast.dart';

class Transfer extends StatefulWidget {
  UserModel user;
  int userId;

  Transfer(this.user, this.userId);

  @override
  TransferState createState() => TransferState(this.user, this.userId);
}

class TransferState extends State<Transfer> {
  UserModel user;
  int userId;
  bool _saving = false;
  var _currentIndex;
  List<String> fromAccounts = List();
  List<String> toAccounts = List();
  int selectedRadioFrom;
  int selectedRadioTo;
  String selectedFromAccount;
  String selectedToAccount;
  final textFieldController = TextEditingController();

  TransferState(this.user, this.userId);

  @override
  void initState() {
    super.initState();
    selectedRadioFrom = 0;
    selectedRadioTo = 0;
    selectedFromAccount = "";
    selectedToAccount = "";

    getAccount(userId).then((listAcc) {
      for (Account acc in listAcc) {
        setState(() {
          fromAccounts.add(acc.number);
        });
      }
      print(fromAccounts);
    });
    queryCards(userId).then((listCards) {
      for (Card8A card in listCards) {
        setState(() {
          fromAccounts.add(card.number);
        });
      }
      print(fromAccounts);
    });

    getAccount(user.userId).then((listAcc) {
      for (Account acc in listAcc) {
        setState(() {
          toAccounts.add(acc.number);
        });
      }
      print(toAccounts);
    });
    queryCards(user.userId).then((listCards) {
      for (Card8A card in listCards) {
        setState(() {
          toAccounts.add(card.number);
        });
      }
      print(toAccounts);
    });
  }

  @override
  void dispose() {
    textFieldController.dispose();
    fromAccounts = List();
    toAccounts = List();
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
            user.name,
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
          listAccountsCards(userId, true),
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
          listAccountsCards(userId, false),
          Container(
              margin: const EdgeInsets.only(right: 40, left: 100),
              child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'monto',
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
                    tranferir(monto, user, userId, context);
                  })),
        ],
      ),
    );
  }

  Future tranferir(
      String monto, UserModel user, int userId, BuildContext context) async {
    setState(() {
      _saving = true;
    });

    String fromAccount = selectedFromAccount;
    String toAccount = selectedToAccount;

    if (fromAccount.length > 0 && toAccount.length > 0) {
      var client = new http.Client();
      try {
        Map<String, String> headers = {"Content-type": "application/json"};
        String jsonBody = getJson(fromAccount, toAccount, monto);
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
            Toast.show("TRansferencia Enviada Exitosamente", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            textFieldController.text = "";
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

  String getJson(String fromAccount, String toAccount, String monto) {
    String fromType = getType(fromAccount);
    String toType = getType(toAccount);
    String jsonBody = '''
    {"origin": "$fromAccount",
        "origin_type": "$fromType",
        "target": "$toAccount",
        "target_type": "$toType",
        "amount": "$monto",
        "type": "FOUNDS_TRANSFER"
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
    List<Widget> widgetsToLoad = List();
    if (from) {
      widgetsToLoad = radioAccountsFrom(fromAccounts);
    } else {
      widgetsToLoad = radioAccountsTo(toAccounts);
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: widgetsToLoad);
  }

  List<Widget> radioAccountsFrom(List<String> accounts) {
    List<Widget> widgets = [];
    for (String acc in accounts) {
      widgets.add(RadioListTile(
        value: acc,
        groupValue: selectedFromAccount,
        title: Text(acc),
        //subtitle: Text(acc),
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

  List<Widget> radioAccountsTo(List<String> accounts) {
    List<Widget> widgets = [];
    for (String acc in accounts) {
      widgets.add(RadioListTile(
        value: acc,
        groupValue: selectedToAccount,
        title: Text(acc),
        //subtitle: Text(acc),
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

  setSelectedRadioFrom(String val) {
    setState(() {
      selectedFromAccount = val;
    });
  }

  setSelectedRadioTo(String val) {
    setState(() {
      selectedToAccount = val;
    });
  }
}
