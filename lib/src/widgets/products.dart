import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/models/account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card8a.dart';
import 'package:flutter_wallet_ui_challenge/src/models/payment_model.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/movements.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';

class ProductsListWidget extends StatefulWidget {
  final int userId;

  const ProductsListWidget(this.userId);

  @override
  State<StatefulWidget> createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  List<ProductModel> products = List();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    //loadData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    products = List();
    super.dispose();
  }

  void loadData() {
    getAccount(widget.userId).then((listAcc) {
      for (Account acc in listAcc) {
        setState(() {
          products.add(ProductModel(
              Icons.monetization_on,
              Color(0xFFffd60f),
              acc.alias + " - " + acc.obfuscated,
              acc.number,
              acc.type,
              double.parse(acc.available_balance),
              1,
              acc.alias,
              acc.obfuscated,
              ""));
        });
      }
    });
    queryCards(widget.userId).then((listCards) {
      for (Card8A card in listCards) {
        setState(() {
          products.add(ProductModel(
              Icons.credit_card,
              getBrandColor(card.brand),
              card.brand,
              card.number,
              "creditcard",
              double.parse(card.available_quota),
              1,
              card.brand,
              card.number.replaceAll("-", ""),
              card.next_payment_day));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget list = ListView.separated(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 85.0),
            child: Divider(),
          );
        },
        padding: EdgeInsets.zero,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                goToMovementsPage(index);
              },
              child: getRow(products[index]));
        });
    return list;
  }

  Container getRow(ProductModel payment) {
    return Container(
      child: ListTile(
        dense: true,
        trailing: Text(
          "${payment.paymentType > 0 ? "+" : "-"} \$ ${payment.amount}",
          style: TextStyle(
              inherit: true, fontWeight: FontWeight.w700, fontSize: 16.0),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Material(
            elevation: 10,
            shape: CircleBorder(),
            shadowColor: payment.color.withOpacity(0.4),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: payment.color,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Icon(
                  payment.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              payment.name,
              style: TextStyle(
                  inherit: true, fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(payment.obfuscated,
                  style: TextStyle(
                      inherit: true, fontSize: 12.0, color: Colors.black45)),
              SizedBox(
                width: 20,
              ),
              Text(payment.type == 'creditcard' ? "" : payment.type,
                  style: TextStyle(
                      inherit: true, fontSize: 12.0, color: Colors.black45)),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void goToMovementsPage(int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Movements(products[index])));
  }

  Color getBrandColor(String brand) {
    if(brand.contains("Diners")){
      return Color(0xFF000080);
    } else {
      return Color(0xFF000000);
    }
  }
}
