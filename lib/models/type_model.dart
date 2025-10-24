import 'package:flutter/material.dart';

class TypeModel {
  String name;
  String iconpath;
  Color boxColor;
  BoxShadow shadowBox;

  TypeModel({
    required this.name,
    required this.iconpath,
    required this.boxColor,
    required this.shadowBox,
  });

  static List<TypeModel> getType() {
    List<TypeModel> type = [];

    type.add(
      TypeModel(
        name: 'Beli Pupuk', 
        iconpath: 'assets/icons/beli.svg', 
        boxColor: Colors.white,
        shadowBox: BoxShadow(
          color: Colors.black.withAlpha(150),
          blurRadius: 15,
          spreadRadius: 0.0
        )
      )
    );

    type.add(
      TypeModel(
        name: 'Tukar Pupuk', 
        iconpath: 'assets/icons/tukar.svg', 
        boxColor: Colors.white,
        shadowBox: BoxShadow(
          color: Colors.black.withAlpha(150),
          blurRadius: 15,
          spreadRadius: 0.0
        )
      )
    );

    return type;
  }
}