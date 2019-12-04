import 'package:flutter/foundation.dart';

class TransferAccount {
  final String number;
  final String brand;
  final String logo;

  TransferAccount({@required this.number, @required this.brand, this.logo});

  factory TransferAccount.fromJson(Map<String, dynamic> json) {
    String brand = json['brand'] as String;
    String logo = "assets/images/users/person.png";

    if (brand.contains("Visa")) {
      logo =
          "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png";
    }
    if (brand.contains("Diners")) {
      logo = "https://kvillacreses-eval-diners.apigee.io/files/dc-logo.png";
    }

    return TransferAccount(
      number: json['number'] as String,
      brand: brand,
      logo: logo,
    );
  }
}
