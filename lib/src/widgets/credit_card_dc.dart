import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/models/credit_card_model.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/overview_page.dart';

class CreditCardDC extends StatelessWidget {
  final CreditCardModel card;

  CreditCardDC({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Center(child: loadCardsByType()),
          ])),
      Positioned(
          top: 100,
          right: 36,
          child: Container(
              padding: EdgeInsets.all(7),
              child: Text(
                card.cardNo,
                style: getStyleCardNumber(context),
              ))),
      SizedBox(height: 20),
      Positioned(
          top: 130,
          right: 130,
          child: Container(
              padding: EdgeInsets.all(7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    card.expiryDate,
                    style: getStyleCardNumber(context),
                  )
                ],
              ))),
    ]);
  }

  Widget loadCardsByType() {
    Image image = Image.asset('assets/images/cards/visa.png');
    bool isDiners = card.type;
    if (isDiners) {
      image = Image.asset('assets/images/cards/diners.png');
    }

    return Container(
        child: ClipRRect(
      borderRadius: new BorderRadius.circular(18.0),
      child: image,
    ));
  }

  Color getColorByProduct() {
    if (card.type) {
      return Color(0xFF095c80);
    }
    return Colors.grey.shade50;
  }

  TextStyle getStyleCardNumber(BuildContext context) {
    List<Shadow> shadows = [];
    if (card.type) {
      shadows = [
        Shadow(
            // bottomLeft
            offset: Offset(-1, -1),
            color: Colors.white),
        Shadow(
            // bottomRight
            offset: Offset(1, -1),
            color: Colors.white),
        Shadow(
            // topRight
            offset: Offset(1, 1),
            color: Colors.white),
        Shadow(
            // topLeft
            offset: Offset(-1, 1),
            color: Colors.white),
      ];
      return Theme.of(context).textTheme.headline.copyWith(
          color: getColorByProduct(),
          fontWeight: FontWeight.bold,
          shadows: shadows);
    }
    return Theme.of(context)
        .textTheme
        .headline
        .copyWith(color: getColorByProduct(), fontWeight: FontWeight.bold);
  }
}

class CardDCWidget extends StatefulWidget {
  final int userId;

  const CardDCWidget(this.userId);

  @override
  State<StatefulWidget> createState() => _CardDCWidgetState();
}

class _CardDCWidgetState extends State<CardDCWidget> {
  List<CreditCardModel> cards = List();

  @override
  void initState() {
    super.initState();
    queryCards(widget.userId).then((listCards) {
      for (Card8A card in listCards) {
        setState(() {
          cards.add(CreditCardModel(
              card.number, getLogo(card.brand), "06/23", "192", getType(card)));
        });
      }
    });
  }

  @override
  void dispose() {
    cards = List();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 10),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => OverviewPage())),
            child: CreditCardDC(
              card: cards[index],
            ),
          ),
        );
      },
    );
  }

  bool getType(Card8A card) {
    if (card.brand.contains("Visa")) {
      return false;
    }
    return true;
  }
}
