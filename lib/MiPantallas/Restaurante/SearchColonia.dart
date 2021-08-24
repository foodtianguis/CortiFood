import 'dart:convert';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/ColoniasModel.dart';
import 'package:flutter/material.dart';

class SearchColonia extends SearchDelegate {
  //final List<String> listExample;
  String sBusqueda = "Buscar";
  SearchColonia()
      : super(
          searchFieldLabel: "Buscar",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  int _Estatus;
  int _Result;
  String sResult = "";
  String sQuery = "";
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_outlined),
      onPressed: () =>
          Navigator.pushReplacementNamed(context, '/RestBusquedaColonia'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: query != '' ? BusquedaList(query) : null,
    );
  }

  List<String> recentList = ["Text 4", "Text 3"];
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            sResult = suggestionList[index];
            showResults(context);
          },
        );
      },
      itemCount: suggestionList.length,
    );
  }

  ListView BusquedaList(String sBusqueda) {
    return ListView(
      children: <Widget>[
        FutureBuilder<List<ColoniasModel>>(
          future: TraeColoniasXZonaEspecifica(
              Restaurant.id_Restaurant, 3, sBusqueda), //MenuView(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ColoniasModel> data = snapshot.data;
              if (data.length == 0)
                return Container(
                  child: Center(
                    child: Text(
                      'Sin Resultados',
                      style: EstiloLetraLB,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 200),
                );
              else
                return _jobsListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              heightFactor: 500,
              child: CircularProgressIndicator(
                backgroundColor: ColorApp,
                valueColor: new AlwaysStoppedAnimation<Color>(splashBtn),
              ),
            );
          },
        ),
        SizedBox(
          height: 200,
        ),
      ],
    );
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          _Estatus = 2;
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
                _Estatus = 1;
                query = "";
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
                _Estatus = 1;
                query = "";
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

  Future<List<ColoniasModel>> TraeColonias(
      int id_Restaurant, int Estado, String sBusqueda) async {
    final repose = await http.get(CadenaConexion(
        "Restaurant/ViewColonias/${id_Restaurant}/${Estado}/${sBusqueda}"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      List jsonResponse = json.decode(repose.body);
      return jsonResponse.map((job) => ColoniasModel.fromJson(job)).toList();
    } else {
      throw Exception("Fallo!");
    }
  }

  Future<List<ColoniasModel>> TraeColoniasXZonaEspecifica(
      int id_Restaurant, int Estado, String sBusqueda) async {
//    final repose = await http.get(CadenaConexion("Restaurant/ViewColonias/${id_Restaurant}/${Estado}/${sBusqueda}"));
    final repose = await http.get(CadenaConexion(
        "Restaurant/ViewColoniasXZonaEspecifica/${id_Restaurant}/${Estado}/Z/${sBusqueda}"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      List jsonResponse = json.decode(repose.body);
      return jsonResponse.map((job) => ColoniasModel.fromJson(job)).toList();
    } else {
      throw Exception("Fallo!");
    }
  }
}
