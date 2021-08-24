import 'dart:convert';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/InfoAdeudoXRestaurantModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ComisionRestaurant extends StatefulWidget {
  @override
  ComisionRestaurantState createState() => ComisionRestaurantState();
}

class ComisionRestaurantState extends State<ComisionRestaurant> {
  InfoAdeudoXRestaurantModel ComisionesRestaurant;
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    TraeComisionesRestaurant(Restaurant.id_Restaurant);
  }

  Future<void> TraeComisionesRestaurant(int id_Restaurant) async {
    final repose = await get(CadenaConexion(
        "Restaurant/InfoAdeudoXRestaurantQuincenal/${id_Restaurant}"));
    var statusCode = repose.statusCode;
    if (statusCode == 200 || repose.statusCode == 201) {
      setState(() {
        ComisionesRestaurant =
            InfoAdeudoXRestaurantModel.fromJson(json.decode(repose.body)[0]);
      });
    } else {
      throw Exception("Fallo!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            'Total de Pedidos = ${ComisionesRestaurant?.CantPedidos ?? 0}',
          ),
          alignment: Alignment.centerLeft,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            'Comision a pagar = \$ ${ComisionesRestaurant?.ComisionTotal ?? 0}',
          ),
          alignment: Alignment.centerLeft,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            ComisionesRestaurant?.Periodo ?? '',
          ),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
