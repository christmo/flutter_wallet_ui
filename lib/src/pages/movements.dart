import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/models/movement.dart';
import 'package:flutter_wallet_ui_challenge/src/models/payment_model.dart';
import 'package:flutter_wallet_ui_challenge/src/models/transfer_account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/user_model.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert' as convert;
import 'package:toast/toast.dart';

import 'home_page.dart';

class Movements extends StatefulWidget {
  final ProductModel product;

  Movements(this.product);

  @override
  MovementsState createState() => MovementsState();
}

class MovementsState extends State<Movements> {
  List<Movement> movements = List();
  double amount = 0.0;
  String paymentDay = "";

  MovementsState();

  @override
  void initState() {
    loadAccountMovements();
    super.initState();
  }

  void loadAccountMovements() {
    String type = widget.product.type;
    if (type != 'creditcard') {
      getMovementsAccounts(widget.product.number).then((listMovements) {
        setState(() {
          listMovements = listMovements.reversed.toList();
          movements = listMovements;
          amount = widget.product.amount;
        });
      });
    } else {
      getMovementsCards(widget.product.number).then((cardMovements) {
        setState(() {
          cardMovements.movements = cardMovements.movements.reversed.toList();
          movements = cardMovements.movements;
          amount = double.parse(cardMovements.total_to_payment);
          paymentDay = cardMovements.next_court_day;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    movements = List();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return rows(context);
  }

  Widget rows(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 40, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Movimientos ",
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
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "${widget.product.name}",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
              child: colorCard(
            widget.product.type == 'savings' ? "Saldo" : "Por Pagar",
            amount,
            1,
            context,
            getBrandColor(widget.product.brand),
          )),
          SizedBox(
            height: 15,
          ),
          loadMovements()
        ],
      ),
    );
  }

  Widget loadMovements() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: movements.length,
        itemBuilder: (BuildContext context, int index) {
          return getRow(movements[index]);
        });
  }

  Container getRow(Movement movement) {
    return Container(
      child: ListTile(
        dense: true,
        trailing: Text(
          "${movement.type == 'CREDIT' ? "+" : "-"} \$ ${movement.amount}",
          style: TextStyle(
              inherit: true,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: movement.type == 'CREDIT' ? Colors.green : Colors.red),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Material(
            elevation: 10,
            shape: CircleBorder(),
            shadowColor: movement.color.withOpacity(0.4),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: movement.color,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Icon(
                  movement.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: new Container(
                padding: new EdgeInsets.only(right: 13.0),
                child: new Text(
                  movement.description.toLowerCase(),
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(movement.date,
                  style: TextStyle(
                      inherit: true, fontSize: 12.0, color: Colors.black45)),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorCard(
      String text, double amount, int type, BuildContext context, Color color) {
    final _media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
      padding: EdgeInsets.all(10),
      height: screenAwareSize(100, context),
      width: _media.width / 1.8,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 0.2,
                offset: Offset(0, 8)),
          ]),
      child: Stack(
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${type > 0 ? "" : "-"} \$ ${amount.toString()}",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                    visible: paymentDay.length > 0 ? true : false,
                    child: Text(
                      paymentDay.length > 0
                          ? DateFormat.yMd()
                              .format(DateFormat.yMd().parse(paymentDay))
                          : "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ]),
          loadCardImage(
              widget.product.isDiners, getLogo(widget.product.brand), 2)
        ],
      ),
    );
  }

  Color getBrandColor(String brand) {
    if (brand.contains("Diners")) {
      return Color(0xFF000080);
    } else {
      return Color(0xFF000000);
    }
  }
}
