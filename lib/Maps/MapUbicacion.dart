import 'dart:async';
import 'dart:convert';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class MapUbicacion extends StatefulWidget {
  final LatLng llTraeUbica;

  const MapUbicacion({Key key, this.llTraeUbica}) : super(key: key);
  @override
  _MapUbicacionState createState() => _MapUbicacionState();
}

class _MapUbicacionState extends State<MapUbicacion> {
  GoogleMapController _controller;
  Set<Marker> Marca = Set();
  LatLng posicion;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  BitmapDescriptor MyIcon;
  String _Direccion;

  CameraPosition _kGooglePlex;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
          ? jSon["results"][1]["formatted_address"]
          : "";
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
          Text(
            "Dirección: ${_Direccion}",
            //style: EstiloLetraBtn,
          ),
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
      if (widget.llTraeUbica != null) {
        _kGooglePlex = CameraPosition(
          target:
              LatLng(widget.llTraeUbica.latitude, widget.llTraeUbica.longitude),
          zoom: 15,
        );
      } else if (currentLocation != null) {
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
          markerId: MarkerId(user.id.toString()),
          position: _kGooglePlex.target,
          //icon: MyIcon,
          infoWindow: InfoWindow(
              title: Restaurant.Nombre, snippet: Restaurant.Domicilio)));
      dLatitud = _kGooglePlex.target.latitude;
      dLongitud = _kGooglePlex.target.longitude;
      TraeCPLatitudLongitud(dLatitud, dLongitud);
      _controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    });
  }

  @override
  void initState() {
    super.initState();
    _kGooglePlex =
        CameraPosition(target: LatLng(25.5631061, -108.4695988), zoom: 15);
    setInitialLocation();
  }

  Future<void> _goToTheLake() async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class MapWin extends StatefulWidget {
  final LatLng llTraeUbica;

  const MapWin({Key key, this.llTraeUbica}) : super(key: key);
  @override
  MapWinState createState() => MapWinState(llTraeUbica);
}

class MapWinState extends State<MapWin> {
  final LatLng llTraeUbica;

  Set<Marker> Marca = Set();
  LatLng posicion;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  CameraPosition _kGooglePlex;

  MapWinState(this.llTraeUbica);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        zoomGesturesEnabled: false,
        zoomControlsEnabled: false,
        scrollGesturesEnabled: false,
        mapToolbarEnabled: false,
        markers: Marca,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    location = new Location();
    location.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
    });
    setState(() {
      if (llTraeUbica != null) {
        setState(() {
          _kGooglePlex = CameraPosition(
            target: llTraeUbica,
            zoom: 15,
          );
          posicion = llTraeUbica;
          Marca = Set();
          if (Restaurant != null) {
            Marca.add(Marker(
                markerId: MarkerId('MiPosicion'),
                position: posicion,
                infoWindow: InfoWindow(
                    title: Restaurant.Nombre, snippet: Restaurant.Domicilio)));
          } else {
            Marca.add(Marker(
              markerId: MarkerId('MiPosicion'),
              position: posicion,
            ));
          }
        });
      } else if (currentLocation != null) {
        _kGooglePlex = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15,
        );
        Marca = Set();
        Marca.add(Marker(
          markerId: MarkerId('MiPosicion'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
        ));
      } else {
        _kGooglePlex = CameraPosition(
          target: LatLng(25.5631061, -108.4695988),
          zoom: 15,
        );
        Marca = Set();
        Marca.add(Marker(
          markerId: MarkerId('MiPosicion'),
          position: LatLng(25.5631061, -108.4695988),
        ));
      }
      dLatitud = _kGooglePlex.target.latitude;
      dLongitud = _kGooglePlex.target.longitude;
    });
  }
}
