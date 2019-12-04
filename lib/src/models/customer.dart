import 'package:flutter/foundation.dart';

class Customer {
  final String email;
  final String id;
  final String last_name;
  final String name;
  final String fotoAsset;

  Customer(
      {@required this.email,
      @required this.id,
      @required this.last_name,
      @required this.name,
      @required this.fotoAsset});

  factory Customer.fromJson(Map<String, dynamic> json) {
    String name = json['name'] as String;
    String foto = "assets/images/users/person.png";

    if(name == "Adrian"){
      foto = "assets/images/users/adrian.jpeg";
    }
    if(name == "Xavier"){
      foto = "assets/images/users/xavi.jpeg";
    }
    if(name == "Karla"){
      foto = "assets/images/users/karla.jpeg";
    }
    if(name == "Christian"){
      foto = "assets/images/users/chris.jpeg";
    }
    if(name == "Ivan"){
      foto = "assets/images/users/ivan.jpeg";
    }

    return Customer(
      email: json['email'] as String,
      id: json['id'] as String,
      last_name: json['last_name'] as String,
      name: name,
      fotoAsset: foto,
    );
  }
}
