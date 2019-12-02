import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/credit_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/credit_card_dc.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';

import 'overview_page.dart';

Widget superior(Size media, BuildContext context, int userId) {
  return Container(
    color: Colors.grey.shade50,
    height: media.height / 2,
    child: Stack(
      children: <Widget>[
        fondoSuperior(media),
        ListCards(media: media),
        tituloBotonesSuperiores(media, context)
      ],
    ),
  );
}

class ListCards extends StatefulWidget {
  final Size media;

  const ListCards({Key key, this.media}) : super(key: key);

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
    return tarjetas(widget.media);
  }

  Widget tarjetas(Size media) {
    FutureBuilder<List<Card8A>>(
        future: queryCards(4),
        builder: (context, snapshot){
          if(snapshot.hasData){
            cards = snapshot.data;
            print("Exito "+ cards[0].number);
          }
          print("Salio Exito");
        }
    );
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
        ),
        height: media.longestSide <= 775 ? media.height / 4 : media.height / 4.3,
        width: media.width,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: getCreditCards().length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OverviewPage())),
                  child: CreditCardDC(
                    card: getCreditCards()[index],
                  ),
                ),
              );
            },
          ),
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
                    image: AssetImage("assets/images/bg3.jpg"),
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

Widget tituloBotonesSuperiores(Size _media, BuildContext context) {
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
        ],
      ));
}
