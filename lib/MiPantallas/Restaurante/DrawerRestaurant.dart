import 'dart:convert';

import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiPantallas/Restaurante/ColoniasRestaurant.dart';
import 'package:dartxero/MiPantallas/Restaurante/ComisionRestaurant.dart';
import 'package:dartxero/MiPantallas/Usuario/DatosUsuario.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart' as Acc;
import 'package:http/http.dart' as http;
import 'DatosRestaurante.dart';

class DrawerRest extends StatefulWidget {
  @override
  DrawerRestState createState() => DrawerRestState();
}

class DrawerRestState extends State<DrawerRest> {
  bool _Activa = false;
  String _OnLine = '';
  DecorationImage ImagenHeader() {
    return Restaurant != null
        ? (Restaurant.logo != null && Restaurant.logo != ""
            ? DecorationImage(
                image: Acc.Imagen(Restaurant.logo),
                alignment: Alignment.centerRight,
              )
            : DecorationImage(
                image: AssetImage(sLogoPerfilDefault),
                alignment: Alignment.centerRight))
        : DecorationImage(
            image: AssetImage(sLogoPerfilDefault),
            alignment: Alignment.centerRight);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    VerificaEstado(Restaurant.id_Restaurant, 0);
  }

  Future<void> VerificaEstado(int id_Restaurant, int Accion) async {
    //final response = await http.get("${sURL}Restaurante/RegistrarEntSal/${id_Restaurant}/${Accion}",);
    final response = await http.get(
      CadenaConexion("Restaurante/RegistrarEntSal/${id_Restaurant}/${Accion}"),
    );
    var Result = json.decode(response.body);
    setState(() {
      //_Activa = (Result.length != 0)?(Result[0] == true) ? true :false :false;
      _Activa = Result[0]["Activa"];
      _OnLine = _Activa == true ? 'En Linea' : 'Fuera Linea';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Container(
          width: double.maxFinite,
          height: 100,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: ColorApp,
              image: ImagenHeader(),
            ),
            child: Text(
              Restaurant != null ? Restaurant.Nombre : sNomApp,
              style: EstiloLetraDrawer,
              //maxLines: 5,
            ),
          ),
        ),
        ListTile(
          leading: Container(
            child: Switch(
              value: _Activa,
              onChanged: (value) {
                VerificaEstado(Restaurant.id_Restaurant, 1);
              },
            ),
          ),
          title: Text(_OnLine),
        ),
        ListTile(
          leading: Container(
            child: iMDs,
            width: 60,
          ),
          title: Text("Usuario"),
          onTap: () {
            vDatosUsuario(context, 2);
          },
        ),
        ListTile(
          leading: Container(
            child: iRes,
            width: 60,
          ),
          title: Text(sMiRestaurant),
          onTap: () {
            vDatosRestaurente(context);
          },
        ),
        ListTile(
          leading: Container(
            child: iRuta,
            width: 60,
          ),
          title: Text(sRuta),
          onTap: () {
            //AddColoniaRestaurant(context, Restaurant.id_Restaurant);
            Navigator.pushReplacementNamed(context, '/RestBusquedaColonia');
          },
        ),
        ListTile(
          leading: Container(
            child: iConf,
            width: 60,
          ),
          title: Text(sConfig),
          onTap: () {
            Navigator.pushNamed(context, '/ConfiguracionRestaurant');
          },
        ),
        ListTile(
          leading: Container(
            child: iCerrarSecion,
            width: 60,
          ),
          title: Text(sCerrarSecion),
          onTap: () => {vCerrarSeccion(context)},
        ),
        ListTile(
          leading: Container(
            child: iSalir,
            width: 60,
          ),
          title: Text(sSalir),
          onTap: () => vSalir(),
        ),
        Flexible(
          child: SizedBox(
            height: 0,
          ),
          flex: 3,
          fit: FlexFit.tight,
        ),
        Container(
          child: ComisionRestaurant(),
          decoration: BoxDecoration(
              border: Border.all(
                color: ColorLineas,
                width: 5,
              ),
              //borderRadius: BorderRadius.circular(10),
              //borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              color: ColorFondo),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          margin: EdgeInsets.all(10),
        ),
        //Flexible(child: SizedBox(height: 0,),flex: 3,fit: FlexFit.tight,),
        //Container(child: Image.asset('Utilerias/Imagen/CANIRAC.png'),height: 100,width: 100,alignment: Alignment.bottomCenter,),
      ]),
    );
  }
}
