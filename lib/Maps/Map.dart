import 'dart:async';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  final LatLng llTraeUbica;

  const MapSample({Key key, this.llTraeUbica}) : super(key: key);
  @override
  MapSampleState createState() => MapSampleState(llTraeUbica);
}

class MapSampleState extends State<MapSample> {
  final LatLng llTraeUbica;

  GoogleMapController _controller;
  Set<Marker> Marca = Set();
  LatLng posicion;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

  CameraPosition _kGooglePlex;
/*
 CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.5631061, -108.4695988),
    zoom: 10,
  );*/

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  MapSampleState(this.llTraeUbica);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          });
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        //onTap: _goToTheLake,
      ),
    );
  }

  void setInitialLocation() async {
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
        markerId: MarkerId(user.id.toString()),
        position: _kGooglePlex.target,
      ));
      dLatitud = _kGooglePlex.target.latitude;
      dLongitud = _kGooglePlex.target.longitude;
      _controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    });
  }

  @override
  void initState() {
    super.initState();
    location = new Location();
    location.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
    });
    setInitialLocation();
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
          //_controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
        });
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
      dLatitud = _kGooglePlex.target.latitude;
      dLongitud = _kGooglePlex.target.longitude;
    });
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
