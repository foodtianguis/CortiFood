import 'dart:convert';
import 'package:dartxero/Maps/MapUbicacion.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiFramework/miPago.dart';
import 'package:dartxero/MiPantallas/Restaurante/ColoniasRestaurant.dart';
import 'package:dartxero/MiPantallas/Restaurante/ComisionXColonias.dart';
import 'package:dartxero/MiPantallas/Restaurante/DrawerRestaurant.dart';
import 'package:dartxero/MiPantallas/Usuario/Tarjetas.dart';
import 'package:dartxero/Pagos/MetodoCard.dart';
import 'package:dartxero/Pagos/PagoNativo.dart';
import 'package:dartxero/Pagos/Payment.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/TarjetaModel.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:location/location.dart';

class ConfiguracionRestaurant extends StatefulWidget {
  @override
  _ConfiguracionRestaurant createState() => _ConfiguracionRestaurant();
}

class _ConfiguracionRestaurant extends State<ConfiguracionRestaurant> {
  int _id_Restaurant;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationGLB = new Location();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sNomApp,
          style: EstiloletrasTitulo,
        ),
      ),
      drawer: DrawerRest(),
      body: ListView(
        children: [
          /*Row(
          children: [
            Text("Pago Tarjeta"),
            TabFlexible,
            Botones(2),
            MaterialButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => miPago()));
            },
            child: Text("Mi pago"),),
            MaterialButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentClass()));
            },
              child: Text("Tarjeta"),),
            NativePay(),
          ],
        ),*/
          /*Separador,
          AddTarjetasRest(
            id_Usuario: user.id,
          ),*/
          Separador,
          Container(
            child: Column(
              children: [
                Container(
                  child: MapUbicacion(
                    llTraeUbica:
                        LatLng(Restaurant.Latitud, Restaurant.Longitud),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.all(5.0),
          ),
          Separador,
          /*Flexible(
            child: SizedBox(
              height: 300,
              child: AddColonias(
                id_Restaurant: Restaurant.id_Restaurant,
              ),
            ),
          ),*/
          Flexible(
              child: SizedBox(
            child: ComisionXColonias(
              id_Restaurant: Restaurant.id_Restaurant,
            ),
            height: 300,
          )),
        ],
      ),
    );
  }

  Botones(int Opcion) {
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
                AddTarjeta(context, user.id);
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
              onPressed: () {},
            ),
          );
  }
}

class AddTarjetasRest extends StatefulWidget {
  final int id_Usuario;

  const AddTarjetasRest({Key key, this.id_Usuario}) : super(key: key);
  @override
  _AddTarjetasRest createState() => _AddTarjetasRest();
}

class _AddTarjetasRest extends State<AddTarjetasRest> {
  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          ctrl.NoTarjeta.text = data[index].NoTarjeta.toString();
          ctrl.NoTarjetaOculta.text = ctrl.NoTarjeta.text;
          return _tile(context, data[index]);
        });
  }

  Container _tile(context, data) => Container(
          child: Column(children: [
        Row(
          children: [
            Container(
              width: 120,
              child: Text(
                "${data.Alias}",
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
                "${ctrl.NoTarjetaOculta.text}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            TabFlexible,
            Botones(1, data.id_Tarjeta),
          ],
        ),
        //SizedBox(height: 5,)
      ]));

  Botones(int Opcion, int id_Tarjeta) {
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
              onPressed: () {},
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
              onPressed: () {},
            ),
          );
  }

  Future<void> AddTarjeta(
      int Estatus, int id_Restaurant, int id_Localidad) async {
    //final repose = await http.get("${sURL}Usuario/AddTarjeta/${id_Localidad}");
    final repose =
        await http.get(CadenaConexion("Usuario/AddTarjeta/${id_Localidad}"));

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      var jsonResponse = json.decode(repose.body);
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
    return FutureBuilder<List<TarjetaModel>>(
      future: TraeTarjetas(widget.id_Usuario), //MenuView(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TarjetaModel> data = snapshot.data;
          if (data.length == 0)
            return Container(
              child: Center(
                child: Text(
                  'Sin Tarjetas',
                  style: EstiloLetraLB,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 30),
            );
          else {
            return _jobsListView(data);
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
}

Future<List<TarjetaModel>> TraeTarjetas(int id_Usuario) async {
  //final repose = await http.get("${sURL}Usuario/TraeTarjetaUsuario/${id_Usuario}");
  final repose = await http
      .get(CadenaConexion("Usuario/TraeTarjetaUsuario/${id_Usuario}"));

  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => TarjetaModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}
