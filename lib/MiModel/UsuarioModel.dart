import 'dart:convert';

import 'package:flutter/cupertino.dart';

UserModel userModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str[0]));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String Nickname;
  String NumCel;
  String Pass;
  String Activo;
  bool LoginFacebook;
  int TipoUsuario;
  String Nombre;
  String Apellido;
  DateTime FechaNac;
  DateTime FechaReg;
  int TipoPreferencia;
  String Calle;
  String cp;
  String Colonia;
  int numExt;
  int numInt;
  String Ciudad;
  String foto;
  double Latitud;
  double Longitud;
  String Referencia;

  UserModel(
      {this.id,
      this.Nickname,
      this.NumCel,
      this.Pass,
      this.Activo,
      this.LoginFacebook,
      this.TipoUsuario,
      this.Nombre,
      this.Apellido,
      this.FechaNac,
      this.FechaReg,
      this.TipoPreferencia,
      this.Calle,
      this.cp,
      this.Colonia,
      this.numExt,
      this.numInt,
      this.Ciudad,
      this.foto,
      this.Latitud,
      this.Longitud,
      this.Referencia});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        Nickname: json["Nickname"],
        NumCel: json["NumCel"],
        Pass: json["Pass"],
        Activo: json["Activo"],
        LoginFacebook: json["LoginFacebook"],
        TipoUsuario: json["TipoUsuario"],
        Nombre: json["Nombre"],
        Apellido: json["Apellido"],
        FechaNac: DateTime.parse(json["FechaNac"]),
        FechaReg: DateTime.parse(json["FechaReg"]),
        TipoPreferencia: json["TipoPreferencia"],
        Calle: json["Calle"],
        cp: json["cp"],
        Colonia: json["Colonia"],
        numExt: json["numExt"],
        numInt: json["numInt"],
        Ciudad: json["Ciudad"],
        foto: json["foto"],
        Latitud: json["Latitud"],
        Longitud: json["Longitud"],
        Referencia: json["Referencia"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toInt(),
        "Nickname": Nickname,
        "NumCel": NumCel,
        "Pass": Pass,
        "Activo": Activo,
        "LoginFacebook": LoginFacebook,
        "TipoUsuario": TipoUsuario.toInt(),
        "Nombre": Nombre,
        "Apellido": Apellido,
        "FechaNac": FechaNac.toIso8601String(),
        "FechaReg": FechaReg.toIso8601String(),
        "TipoPreferencia": TipoPreferencia.toInt(),
        "Calle": Calle,
        "cp": cp,
        "Colonia": Colonia,
        "numExt": numExt.toInt(),
        "numInt": numInt.toInt(),
        "Ciudad": Ciudad,
        "foto": foto,
        "Latitud": Latitud,
        "Longitud": Longitud,
        "Referencia": Referencia,
      };
}

class ValCampoUser {
  bool Nickname;
  bool NumCel;
  bool Pass;
  bool Nombre;
  bool Apellido;
  bool FechaNac;
  bool TipoPreferencia;
  bool Calle;
  bool cp;
  bool Colonia;
  bool numExt;
  bool numInt;
  bool Ciudad;
  bool foto;
  bool Latitud;
  bool Longitud;
  bool Referencia;

  ValCampoUser(
      {this.Nickname,
      this.NumCel,
      this.Pass,
      this.Nombre,
      this.Apellido,
      this.FechaNac,
      this.TipoPreferencia,
      this.Calle,
      this.cp,
      this.Colonia,
      this.numExt,
      this.numInt,
      this.Ciudad,
      this.foto,
      this.Latitud,
      this.Longitud,
      this.Referencia});

  void IniciaCampos() {
    Nickname = false;
    NumCel = false;
    Pass = false;
    Nombre = false;
    Apellido = false;
    FechaNac = false;
    TipoPreferencia = false;
    Calle = false;
    cp = false;
    Colonia = false;
    numExt = false;
    numInt = false;
    Ciudad = false;
    foto = false;
    Latitud = false;
    Longitud = false;
    Referencia = false;
  }
}
