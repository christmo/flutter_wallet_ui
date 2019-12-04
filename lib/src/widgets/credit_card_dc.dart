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
    final _media = MediaQuery.of(context).size;
    return Material(
      elevation: 1,
      shadowColor: Colors.grey.shade300,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: _media.width - 40,
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Card no.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  card.cardNo,
                  style: Theme.of(context).textTheme.headline.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Expira",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(card.expiryDate,
                        style: Theme.of(context).textTheme.headline.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ))
                  ],
                )
              ],
            ),
          ),
          loadCardImage(card.logo),
        ],
      ),
    );
  }

  Widget loadCardImage(String logo) {
    if(card.type){
      return Positioned(
        top: 15,
        right: 15,
        child: Container(
          height: 25,
          width: 50,
          child: Image.asset('assets/images/dc-logo.png'),
        ),
      );
    } else {
      return Positioned(
        top: 15,
        right: 15,
        child: Container(
          height: 25,
          width: 50,
          color: Colors.pink,
          padding: EdgeInsets.all(7),
          child: Image.network(
            card.logo,
            width: 50,
            color: Colors.white,
          ),
        ),
      );
    }
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
              card.number, getLogo(card), "06/23", "192", getType(card)));
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

  String getLogo(Card8A card) {
    if (card.brand.contains("Visa")) {
      return "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png";
    }
    return "https://kvillacreses-eval-diners.apigee.io/files/dc-logo.png";
  }

  bool getType(Card8A card) {
    if (card.brand.contains("Visa")) {
      return false;
    }
    return true;
  }
}
