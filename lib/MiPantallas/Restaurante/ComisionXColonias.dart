import 'dart:convert';

import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/ColoniasModel.dart';
import 'package:dartxero/MiModel/ViewComisionEnvioModel.dart';
import 'package:dartxero/MiPantallas/Restaurante/ColoniasRestaurant.dart';
import 'package:dartxero/MiPantallas/Restaurante/ConfiguracionEnvio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComisionXColonias extends StatefulWidget {
  final int id_Restaurant;

  const ComisionXColonias({Key key, this.id_Restaurant}) : super(key: key);
  @override
  ComisionXColoniasState createState() => ComisionXColoniasState();
}

class ComisionXColoniasState extends State<ComisionXColonias> {
  int _Estatus;
  int _Result;

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(context, data[index]);
        });
  }

  Container _tile(context, data) => Container(
          child: Column(children: [
        Row(
          children: [
            Container(
              width: 140,
              child: Text(
                "${data.Nombre_Colonia}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            //TabFlexibleS,
            Container(
              //width: 120,
              child: Text(
                "\$ ${data?.Comision ?? 0}0",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            BtnBotones(context, data.Comision == 0 ? 2 : 3, data.id_localidad,
                data.id_ComisionEnvio)
          ],
        ),
        //SizedBox(height: 5,)
      ]));

  BtnBotones(BuildContext context, int Opcion, int id_localidad,
      int id_ComisionEnvio) {
    //    2 Add y 1 Remove
    switch (Opcion) {
      case 1:
        {
          return Container(
            width: 15,
            height: 15,
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(
                Icons.remove,
                size: 15,
              ),
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
              onPressed: () {},
            ),
          );
        }
      case 2:
        {
          return Container(
            width: 15,
            height: 15,
            //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 1,)),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 15,
              ),
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
              onPressed: () {
                showConfiguracionEnvio(context, id_localidad, id_ComisionEnvio);
              },
            ),
          );
        }
      case 3:
        {
          return Container(
            width: 15,
            height: 15,
            child: MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Icon(
                Icons.refresh_outlined,
                size: 15,
              ),
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
              onPressed: () {
                showConfiguracionEnvio(context, id_localidad, id_ComisionEnvio);
              },
            ),
          );
        }
    }
  }

  Future<List<ViewComisionEnvioModel>> ViewComisionEnvio(
      int id_Restaurant) async {
    final repose = await http
        .get(CadenaConexion("Restaurant/ViewComisionEnvio/${id_Restaurant}"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      List jsonResponse = json.decode(repose.body);
      return jsonResponse
          .map((job) => ViewComisionEnvioModel.fromJson(job))
          .toList();
    } else {
      throw Exception("Fallo!");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<ViewComisionEnvioModel>>(
        future: ViewComisionEnvio(widget.id_Restaurant), //MenuView(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ViewComisionEnvioModel> data = snapshot.data;
            if (data.length == 0)
              return Container(
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        'Sin Colonias a Entregar',
                        style: EstiloLetraLB,
                      ),
                    ),
                  ],
                ),
              );
            else {
              return Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 10),
                    Titulos(),
                    SizedBox(height: 10),
                    _jobsListView(data),
                    //AddCol(context),
                  ],
                ),
              );
            }
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
      ),
    );
  }

  Container Titulos() {
    return Container(
      child: Row(
        children: [
          Container(
            width: 140,
            child: Text(
              "Colonia",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          //TabFlexibleS,
          Container(
            //width: 120,
            child: Text(
              "Comision de envio",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          // TabFlexible,
        ],
      ),
    );
  }
}
