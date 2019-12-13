import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/credit_card_dc.dart';

Widget superior(
    Size media, BuildContext context, int userId, Customer customer) {
  return Container(
    color: Colors.grey.shade50,
    height: media.height / 1.86,
    child: Stack(
      children: <Widget>[
        fondoSuperior(media),
        ListCards(media: media, userId: userId),
        tituloBotonesSuperiores(media, context, customer),
      ],
    ),
  );
}

class ListCards extends StatefulWidget {
  final Size media;
  final int userId;

  const ListCards({Key key, this.media, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListCardsState();
  }
}

class _ListCardsState extends State<ListCards> {
  List<Card8A> cards;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tarjetas();
  }

  Widget tarjetas() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          left: 15,
        ),
        height: 220,
        width: 330,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: CardDCWidget(widget.userId),
        ),
      ),
    );
  }
}

Widget fondoSuperior(Size media) {
  return Column(
    children: <Widget>[
      Expanded(
        flex: 5,
        child: Stack(
          children: <Widget>[
            Material(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 0.3,
              child: Container(
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(),
      )
    ],
  );
}

Widget tituloBotonesSuperiores(
    Size _media, BuildContext context, Customer customer) {
  return Positioned(
      top: _media.longestSide <= 775
          ? screenAwareSize(20, context)
          : screenAwareSize(35, context),
      left: 10,
      right: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => print("Menu"),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => print("notification"),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Diners Club",
                  style: TextStyle(
                      fontSize: _media.longestSide <= 775 ? 35 : 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Varela"),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: () => print("add"),
              )
            ],
          ),
          Text(
            "Hola " + customer.name,
            style: TextStyle(
                inherit: true,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ],
      ));
}
