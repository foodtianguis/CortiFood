import 'dart:convert';
import 'package:dartxero/MiBD/MiPublicidad.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<List<Publicidad>> fetchPost() async {
  //final repose = await http.get("${sURL}/Base/Publicidad");
  final repose = await http.get(CadenaConexion("Base/Publicidad"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    //var JsonFinal = (json.decode(repose.body)).map((e) => Publicidad.fromJson(e)).toList();
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => new Publicidad.fromJson(job)).toList();
    //return JsonFinal;
  } else {
    throw Exception("Fallo!");
  }
}

class Cartelon extends StatefulWidget {
  @override
  _CartelonState createState() => _CartelonState();
}

class _CartelonState extends State<Cartelon> {
  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,

        //padding: EdgeInsets.symmetric(vertical: 8.0),
        //shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            child: _tile(data[index]),
            padding: EdgeInsets.only(right: 5.0),
          );
          //return _tile(data[index]);
        });
  }

  Container _tile(data) => Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          border: Border.all(
            color: ColorLineas,
            width: 0.5,
          ),
          //borderRadius: BorderRadius.circular(10),
          //borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          color: ColorFondo),
      child: Column(children: [
        Container(
          child:
              Image(height: 100.0, width: 120.0, image: Imagen(data.ImagenPub)),
        ),
        Container(
          width: 120,
          child: Text(
            data.NombrePub,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Flexible(
            child: SizedBox(
          height: 20,
        )),
        Container(
          child: Text(
            data.DescripPub,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
          width: 120,
        ),
        Container(
          child: Text(data.CostoPub.toString()),
          width: 120,
        ),
      ]));

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
            height: 150,
            child: FutureBuilder<List<Publicidad>>(
              future: fetchPost(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Publicidad> data = snapshot.data;
                  return _jobsListView(data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: ColorApp,
                    valueColor: new AlwaysStoppedAnimation<Color>(splashBtn),
                  ),
                );
              },
            ))
      ],
    );
  }
}

Future<bool> EntregaRestaurante(int id_Restaurant, int id_Usuario) async {
  final repose = await http.get(CadenaConexion(
      "Usuario/EntregaRestaurant/${id_Restaurant}/${id_Usuario}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    return json.decode(repose.body);
  } else {
    throw Exception("Fallo!");
  }
}

Future<bool> vEntregaRestaurante(int id_Restaurant, int id_Usuario) async {
  bool Result = await EntregaRestaurante(id_Restaurant, id_Usuario);
  return Result;
}
