import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/UbicacionModel.dart';
import 'package:dartxero/MiPantallas/BandejaEntrada.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

void vMapFloat(BuildContext context) {
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
              //width: double.maxFinite,
              height: 450,
              child: Column(
                children: [
                  MapFloat(),
                ],
              ),
            ),
          ],
        ));
      });
}

class MapFloat extends StatefulWidget {
  final UbicacionModel Ubicacion;

  const MapFloat({Key key, this.Ubicacion}) : super(key: key);
  @override
  _MapFloatState createState() => _MapFloatState();
}

class _MapFloatState extends State<MapFloat> {
  GoogleMapController _controller;
  Set<Marker> Marca = Set();
  LatLng posicion;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  BitmapDescriptor MyIcon;
  String _Direccion;
  String _CP;
  String _Colonia;

  CameraPosition _kGooglePlex;

  void TraeCPLatitudLongitud(double latitude, double longitude) async {
    final response = await get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?key=$sApiKey&latlng=$latitude,$longitude&sensor=true_or_false"),
    );
    var jSon = json.decode(response.body);
    /*var var1 = jSon["results"];
    var var2 = var1[1];
    var var3 = var2["formatted_address"];
    print(var3);*/
    //String sCodigoP = (response.statusCode == 201 || response.statusCode == 200)? jSon["results"]["formatted_address"].value : "" ;
    setState(() {
      _Direccion = (response.statusCode == 201 || response.statusCode == 200)
          ? jSon["results"][0]["formatted_address"] != null
              ? jSon["results"][0]["formatted_address"]
              : ""
          : "";
      _CP = (response.statusCode == 201 || response.statusCode == 200)
          ? jSon["results"][jSon["results"].length - 1]["address_components"][4]
                      ["long_name"] !=
                  null
              ? jSon["results"][jSon["results"].length - 1]
                  ["address_components"][4]["long_name"]
              : ""
          : "";
      _Colonia = (response.statusCode == 201 || response.statusCode == 200)
          ? jSon["results"][jSon["results"].length - 1]["address_components"][1]
                      ["long_name"] !=
                  null
              ? jSon["results"][jSon["results"].length - 1]
                  ["address_components"][1]["long_name"]
              : ""
          : "";
      vAsignaUbicacion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              markers: Marca,

              onTap: (argument) {
                posicion = LatLng(argument.latitude, argument.longitude);
                _controller.animateCamera(CameraUpdate.newLatLng(argument));
                setState(() {
                  if (ValidaRest != null) {
                    ValidaRest.Ubica = dLatitud != argument.latitude ||
                        dLongitud != argument.longitude;
                  }

                  dLatitud = argument.latitude;
                  dLongitud = argument.longitude;
                  Marca = Set();
                  Marca.add(Marker(
                    markerId: MarkerId('MiPosicion'),
                    position: posicion,
                  ));
                  TraeCPLatitudLongitud(dLatitud, dLongitud);
                });
              },
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              //onTap: _goToTheLake,
            ),
            height: 300,
          ),
          Text(_Direccion != null
              ? "Dirección: ${_Direccion}"
              : "Espere un momento"),
          /*SizedBox(height: 10,),
          MaterialButton(
              color: ColorApp,
              textColor: ColorFondoApp,
              child: Text("Confirmar",style: EstiloLetraBtn,),
              onPressed: (){
                vAsignaUbicacion();
                Navigator.of(context).pop();
                //Navigator.pop(context);
              })*/
        ],
      ),
    );
  }

  void setInitialLocation() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), sLogoMap)
        .then((onValue) {
      MyIcon = onValue;
    });
    location = new Location();
    currentLocation = await location.getLocation();
    setState(() {
      if (currentLocation != null) {
        _kGooglePlex = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15,
        );
      } else {
        _kGooglePlex = CameraPosition(
          target: LatLng(25.5631061, -108.4695988),
          zoom: 15,
        );
      }
      Marca = Set();
      Marca.add(Marker(
        markerId: MarkerId("MiDireccion"), position: _kGooglePlex.target,
        //icon: MyIcon,
      ));
      dLatitud = _kGooglePlex.target.latitude;
      dLongitud = _kGooglePlex.target.longitude;
      TraeCPLatitudLongitud(dLatitud, dLongitud);
      _controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    });
  }

  @override
  void initState() {
    super.initState();
    UbicacionUsuario = null;
    _kGooglePlex =
        CameraPosition(target: LatLng(25.5631061, -108.4695988), zoom: 15);
    setInitialLocation();
  }

  void vAsignaUbicacion() {
//    if (UbicacionUsuario = null)
//      UbicacionUsuario = UbicacionModel();
    if (_Direccion != null && _Direccion != "") {
      UbicacionUsuario = UbicacionModel();

      UbicacionUsuario.Ubicacion = _Direccion;
      UbicacionUsuario.UbicacionCP = _CP;
      UbicacionUsuario.Colonia = _Colonia;
      UbicacionUsuario.Latitud = _kGooglePlex.target.latitude;
      UbicacionUsuario.Longitud = _kGooglePlex.target.longitude;
    }
  }
}
