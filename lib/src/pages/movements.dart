import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/movement.dart';
import 'package:flutter_wallet_ui_challenge/src/models/payment_model.dart';
import 'package:intl/intl.dart';

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
      getMovementsCards(widget.product.number, widget.product.brand).then((cardMovements) {
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
          Center(child: colorCard()),
          SizedBox(
            height: 15,
          ),
          perPayAndCourt(),
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
              height: 30,
              width: 30,
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

  Widget colorCard() {
    Image image;
    String type = widget.product.type;
    if (type != 'creditcard') {
      image = Image.asset('assets/images/cards/savings.jpg');
    } else {
      if (widget.product.isDiners) {
        image = Image.asset('assets/images/cards/diners.png');
      } else {
        image = Image.asset('assets/images/cards/visa.png');
      }
    }

    return Container(
        height: 150,
        width: 260,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(18.0),
          child: image,
        ));
  }

  Color getBrandColor(String brand) {
    if (brand.contains("Diners")) {
      return Color(0xFF000080);
    } else {
      return Color(0xFF000000);
    }
  }

  Widget perPayAndCourt() {
    return Padding(
        padding: const EdgeInsets.only(
            left: 80.0, right: 80.0, top: 8.0, bottom: 8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.product.type == 'savings' ? "Saldo" : "Por Pagar",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${1 > 0 ? "" : "-"} \$ ${amount.toString()}",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
              Visibility(
                  visible: paymentDay.length > 0 ? true : false,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Día de Corte',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Spacer(),
                        Text(
                          paymentDay.length > 0
                              ? DateFormat.yMd()
                                  .format(DateFormat.yMd().parse(paymentDay))
                              : "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ]))
            ]));
  }
}
