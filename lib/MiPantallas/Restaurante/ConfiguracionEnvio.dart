import 'dart:convert';

import 'package:dartxero/MiFramework/MiAccionesEmpresa.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/ComisionEnvioModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void showConfiguracionEnvio(
    BuildContext context, int id_localidad, int id_ComisionEnvio) {
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
              height: 400,
              //height: HeightVentana(sMsj),//200,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          sDescripcion,
                          style: EstiloLetraBtnchico,
                        ),
                        width: 100,
                      ),
                      Container(
                        child: Text(
                          sComision,
                          style: EstiloLetraBtnchico,
                        ),
                        width: 70,
                      ),
                      Container(
                        child: Text(
                          sComisionApp,
                          style: EstiloLetraBtnchico,
                        ),
                        width: 100,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ConfiguracionEnvio(
                          id_localidad: id_localidad,
                          id_ComisionEnvio: id_ComisionEnvio)),
                ],
              ),
            ),
          ],
        ));
      });
}

class ConfiguracionEnvio extends StatefulWidget {
  final int id_localidad;
  final int id_ComisionEnvio;

  const ConfiguracionEnvio({Key key, this.id_ComisionEnvio, this.id_localidad})
      : super(key: key);

  @override
  ConfiguracionEnvioState createState() => ConfiguracionEnvioState();
}

class ConfiguracionEnvioState extends State<ConfiguracionEnvio> {
  bool Resul;

  List<DropdownMenuItem<ComisionEnvioModel>> _dropdownButton;
  List<ComisionEnvioModel> ComisionEnvioItem;
  ComisionEnvioModel _selected;

  DropdownButton<ComisionEnvioModel> ComboBox(int Selec) {
    setState(() {
      ViewComisionEnvio(Selec);
      _dropdownButton = buildDropDownButton(ComisionEnvioItem);
    });

    if (Selec == null) {
      _selected = _dropdownButton[0].value;
    } else {
      for (int i = 0; i <= _dropdownButton.length - 1; i++)
        if (_dropdownButton[i].value.id_ComisionEnvio == Selec) {
          _selected = _dropdownButton[i].value;
        }
    }
    return DropdownButton<ComisionEnvioModel>(
        style: EstiloLetraLB,
        underline: Container(
          height: 0,
          color: ColorApp,
        ),
        value: _selected,
        items: _dropdownButton,
        onChanged: (value) {
          setState(() {
            _selected = value;
            txtComisionEnvio.text = value.Comision.toString();
            txtIdComisionEnvio.text = value.id_ComisionEnvio.toString();
          });
        });
  }

  List<DropdownMenuItem<ComisionEnvioModel>> buildDropDownButton(
      List<ComisionEnvioModel> listItems) {
    List<DropdownMenuItem<ComisionEnvioModel>> items = List();
    for (ComisionEnvioModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.Comision.toString()),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<List<ComisionEnvioModel>> ViewComisionEnvio(
      int id_ComisionEnvio) async {
    final repose = await get(CadenaConexion("Restaurant/ComisionEnvio"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      //var jsonResponse = json.decode(repose.body);
      //ComisionEnvioItem.map((job) => ComisionEnvioModel.fromJson(job)).toList();
      //return jsonResponse.map((job) => ComisionEnvioModel.fromJson(job)).toList();
      List jsonResponse = json.decode(repose.body);
      return jsonResponse
          .map((job) => ComisionEnvioModel.fromJson(job))
          .toList();
    } else {
      throw Exception("Fallo!");
    }
  }

  Future<bool> AddComisionRestaurantXLocalidad(
      int id_localidad, int id_Restaurant, int id_ComisionEnvio) async {
    final repose = await post(CadenaConexion(
        "Restaurant/AddComisionRestaurantXLocalidad/${id_localidad}/${id_Restaurant}/${id_ComisionEnvio}"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      //var jsonResponse = json.decode(repose.body);
      //ComisionEnvioItem.map((job) => ComisionEnvioModel.fromJson(job)).toList();
      //return jsonResponse.map((job) => ComisionEnvioModel.fromJson(job)).toList();
      return true;
    } else {
      //throw Exception("Fallo!");
      return false;
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return //Container(
              //child:
              _tile(context, data[index]);
          //margin: EdgeInsets.symmetric(vertical: 1),
          //padding: EdgeInsets.only(top: 5,),
          //);
        });
  }

  MaterialButton _tile(context, data) => MaterialButton(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            //Text('Comision :'),
            //id_ComisionEnvio
            //TipoComision
            //SizedBox(width: 5,),
            Container(
              child: Text(data.Descripcion),
              width: 90,
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              child: Text(data.Comision.toString()),
              width: 70,
            ),
            SizedBox(
              width: 5,
            ),
            Text(data.ComisionApp.toString()),
          ],
        ),
        color: ColorApp,
        onPressed: () async {
          print('${data.id_ComisionEnvio}');
          Resul = await AddComisionRestaurantXLocalidad(widget.id_localidad,
              Restaurant.id_Restaurant, data.id_ComisionEnvio);
          if (Resul)
            Navigator.pushReplacementNamed(context, '/ConfiguracionRestaurant');
          else
            Navigator.of(context).pop();
        },
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        FutureBuilder<List<ComisionEnvioModel>>(
          future: ViewComisionEnvio(widget.id_ComisionEnvio),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ComisionEnvioModel> data = snapshot.data;
              if (data.length == 0)
                return Container(
                  child: Center(
                    child: Text(
                      'No Hay Pedidos',
                      style: Estiloletrasbdj,
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
              child: CircularProgressIndicator(
                backgroundColor: ColorApp,
                valueColor: new AlwaysStoppedAnimation<Color>(splashBtn),
              ),
            );
          },
        ),
      ],
    );
  }
}
