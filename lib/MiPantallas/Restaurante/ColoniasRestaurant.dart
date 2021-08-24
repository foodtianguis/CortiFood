import 'dart:convert';
import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/ColoniasModel.dart';
import 'package:dartxero/MiPantallas/Restaurante/SearchColonia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void AddColoniaRestaurant(BuildContext context, int id_Restaurant) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.close,
                  ),
                  backgroundColor: Colors.red,
                  radius: 15,
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              child: AddColonias(
                id_Restaurant: id_Restaurant,
              ),
            ),
          ],
        ));
      });
}

class AddColonias extends StatefulWidget {
  final int id_Restaurant;

  const AddColonias({Key key, this.id_Restaurant}) : super(key: key);
  @override
  _AddColonias createState() => _AddColonias();
}

class _AddColonias extends State<AddColonias> {
  int _Estatus;
  int _Result;

  ListView _jobsListView(data, Estado) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          _Estatus = Estado;
          return _tile(context, data[index], _Estatus);
        });
  }

  Container _tile(context, data, Estado) => Container(
          child: Column(children: [
        Row(
          children: [
            Container(
              width: 120,
              child: Text(
                "${data.Nombre_Colonia}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            TabFlexibleS,
            Container(
              //width: 120,
              child: Text(
                "${data.cve_municipio_cp}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            TabFlexible,
            Botones(Estado, Restaurant.id_Restaurant, data.id_localidad),
          ],
        ),
        //SizedBox(height: 5,)
      ]));

  Botones(int Opcion, int id_Restaurant, int id_Localidad) {
    //    2 Add y 1 Remove
    return Opcion == 2
        ? Container(
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
                AccionesColonia(Opcion, id_Restaurant, id_Localidad);
                setState(() {
                  _Estatus = _Result;
                });
              },
            ),
          )
        : Container(
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
              onPressed: () {
                AccionesColonia(Opcion, id_Restaurant, id_Localidad);
                setState(() {
                  _Estatus = _Result;
                });
              },
            ),
          );
  }

  Future<void> AccionesColonia(
      int Estatus, int id_Restaurant, int id_Localidad) async {
    //final repose = await http.get("${sURL}Restaurant/AccionesColonias/${Estatus}/${id_Restaurant}/${id_Localidad}");
    final repose = await http.get(CadenaConexion(
        "Restaurant/AccionesColonias/${Estatus}/${id_Restaurant}/${id_Localidad}"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      var jsonResponse = json.decode(repose.body);
      _Result = jsonResponse == "Listo" ? 2 : 1;
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
    return FutureBuilder<List<ColoniasModel>>(
      future:
          TraeColoniasXZonaEspecifica(widget.id_Restaurant, 1), //MenuView(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ColoniasModel> data = snapshot.data;
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
                  SizedBox(height: 10),
                  Titulos(),
                  Separador,
                  AddCol(context),
                ],
              ),
            );
          else {
            return Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Titulos(),
                  Separador,
                  _jobsListView(data, 1),
                  SizedBox(height: 10),
                  Titulos(),
                  Separador,
                  AddCol(context),
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
    );
  }

  Widget AddCol(BuildContext context) {
    return FutureBuilder<List<ColoniasModel>>(
      future:
          TraeColoniasXZonaEspecifica(widget.id_Restaurant, 2), //MenuView(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ColoniasModel> data = snapshot.data;
          if (data.length == 0)
            return Container(
              child: Center(
                child: Text(
                  'Sin Colonias',
                  style: EstiloLetraLB,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 200),
            );
          else
            return _jobsListView(data, 2);
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
    );
  }

  Container Titulos() {
    return Container(
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              "Colonia",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          TabFlexibleS,
          Container(
            //width: 120,
            child: Text(
              "CP",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          TabFlexible,
        ],
      ),
    );
  }
}

Future<List<ColoniasModel>> TraeColonias(int id_Restaurant, int Estado) async {
  //final repose = await http.get("${sURL}Restaurant/ViewColonias/${id_Restaurant}/${Estado}/Test");
  final repose = await http.get(CadenaConexion(
      "Restaurant/ViewColonias/${id_Restaurant}/${Estado}/Test"));

  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => ColoniasModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}

Future<List<ColoniasModel>> TraeColoniasXZonaEspecifica(
    int id_Restaurant, int Estado) async {
  final repose = await http.get(CadenaConexion(
      "Restaurant/ViewColoniasXZonaEspecifica/${id_Restaurant}/${Estado}/Z/Test"));

  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => ColoniasModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}

Future<bool> TieneColonias(int id_Restaurant) async {
  //final repose = await http.get("${sURL}Restaurant/TieneColonias/${id_Restaurant}");
  final repose = await http
      .get(CadenaConexion("Restaurant/TieneColonias/${id_Restaurant}"));

  if (repose.statusCode == 200 || repose.statusCode == 201) {
    var Result = json.decode(repose.body);
    return Result[0] != 1 ? true : false;
  } else {
    return true;
  }
}
