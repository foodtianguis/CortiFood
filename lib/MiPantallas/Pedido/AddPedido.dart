import 'dart:convert';

import 'package:dartxero/Acciones/Pedidos/AccionPedido.dart';
import 'package:dartxero/Api/Api.dart';
import 'package:dartxero/MiFramework/MiAccionLogin.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiModel/ComisionEnvioCompraModel.dart';
import 'package:dartxero/MiUtilidad/stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class AddPedido extends StatefulWidget {
  final BusquedaModel Data;

  const AddPedido({Key key, this.Data}) : super(key: key);
  @override
  AddPedidoState createState() => AddPedidoState();
}

class AddPedidoState extends State<AddPedido> {
  final _formKey = GlobalKey<FormState>();
  int _Cantidad;
  bool _Activa;
  String _Direccion;
  String _CP;
  String _Colonia;
  LocationData currentLocation;
  bool _bEntregaColonia;
  ComisionEnvioCompraModel _ComisionEnvioCompra;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  Future<void> TraeUbicacion() async {
    Location ubica = Location();
    currentLocation = await ubica.getLocation();
    TraeCPLatitudLongitud(currentLocation.latitude, currentLocation.longitude);
  }

  void vTraeComisionEnvioCompra(
      int id_Restaurant, String CP, String Colonia) async {
    final response = await get(CadenaConexion(
        'Restaurant/TraComisionEnvioCompra/${id_Restaurant}/${CP}/${Colonia}'));
    //final response = await get(CadenaConexion('Restaurant/TraComisionEnvioCompra?id_Restaurant=${id_Restaurant}&CP=${CP}&Colonia=${Colonia}'));
    var jSon = json.decode(response.body);
    setState(() {
      _ComisionEnvioCompra =
          (response.statusCode == 201 || response.statusCode == 200)
              ? response.body != '[]'
                  ? ComisionEnvioCompraModel.fromJson(jSon[0])
                  : null
              : null;
      _bEntregaColonia = _ComisionEnvioCompra?.Comision != null;
    });
  }

  void TraeCPLatitudLongitud(double latitude, double longitude) async {
    final response = await get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?key=$sApiKey&latlng=$latitude,$longitude&sensor=true_or_false"),
    );
    var jSon = json.decode(response.body);
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
      _Activa = true;
      vTraeComisionEnvioCompra(widget.Data.id_restaurant, _CP, _Colonia);
    });
  }

  Future<void> TraeEntregaColonia() async {
    bool result = await vEntregaRestaurante(widget.Data.id_restaurant, user.id);
    setState(() {
      _bEntregaColonia = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _Cantidad = 1;
      _Activa = false;
      _Direccion = "";
      txtCarritoNom.text = widget.Data.menuNombre;
      txtCarritoDesc.text = widget.Data.menuDescripcion;
      txtCarritoNota.text = "";
      _bEntregaColonia = false;

      txtReferenciaEnvio.text = user?.Referencia ?? "";

      //TraeEntregaColonia();
      vTraeComisionEnvioCompra(
          widget.Data.id_restaurant, user.cp, user.Colonia);
    });
  }

  Form Body() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 120.0,
            width: 130.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0)), //color: Colors.cyanAccent,
                image: DecorationImage(image: Imagen(widget.Data.menufoto))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: txtCarritoNom,
            decoration: InpDecoTxt(sNombre),
            style: EstiloLetraLB,
            enabled: false,
            autofocus: true,
          ),
          TextFormField(
            maxLines: 2,
            controller: txtCarritoDesc,
            decoration: InpDecoTxt(sDescripcion),
            style: EstiloLetraLB,
            enabled: false,
          ),
          //SizedBox(height: 10,),
          TextFormField(
            maxLines: 2,
            controller: txtCarritoNota,
            decoration: InpDecoTxt(sNota),
            style: EstiloLetraLB,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Enviar a tu ubicación"),
              TabFlexible,
              Switch(
                value: _Activa,
                onChanged: (value) {
                  setState(() {
                    //_Activa = value;
                    if (value) {
                      TraeUbicacion();
                      txtReferenciaEnvio.text = "";
                    } else {
                      setState(() {
                        _Activa = value;
                        _Direccion = "";
                        _CP = "";
                        _Colonia = "";
                        txtReferenciaEnvio.text = user.Referencia;
                      });
                      vTraeComisionEnvioCompra(
                          widget.Data.id_restaurant, user.cp, user.Colonia);
                    }
                  });
                  //VerificaEstado(Restaurant.id_Restaurant, 1);
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _Direccion != ""
              ? Text(
                  "$_Direccion cp: $_CP",
                  style: TextStyle(color: Colors.black12),
                )
              : Text(
                  '${user.Calle}',
                  style: TextStyle(color: Colors.black12),
                ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 2,
            controller: txtReferenciaEnvio,
            decoration: InpDecoTxt(sReferencia),
            style: _Activa ? EstiloLetraLB : EstiloLetraLBDes,
            enabled: _Activa,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('${sCantidad} :'),
              SizedBox(
                width: 20,
              ),
              StepperTouch(
                initialValue: 1,
                onChanged: (value) {
                  setState(() {
                    _Cantidad = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _ComisionEnvioCompra != null
              ? Row(
                  children: [
                    Text(_ComisionEnvioCompra.Descripcion),
                    Flexible(
                      child: SizedBox(
                        width: 0,
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Text('\$ ${_ComisionEnvioCompra.Comision}',
                        textAlign: TextAlign.left),
                  ],
                )
              : Text(
                  'No se puede Realizar envios a tu dirección',
                  style: EstiloLetraError,
                ) /*Row(
                  children: [
                    Text(sComision2Pt),
                    Flexible(
                      child: SizedBox(
                        width: 0,
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Text('\$ 3.00', textAlign: TextAlign.left),
                  ],
                )*/
          ,
          SizedBox(
            height: 10,
          ),
          _ComisionEnvioCompra?.Comision != null
              ? Row(
                  children: [
                    Text('${sTotal} :'),
                    //SizedBox(width: 20,),
                    Flexible(
                      child: SizedBox(
                        width: 0,
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Text(
                        '\$ ${(_Cantidad * widget.Data.Precio) + _ComisionEnvioCompra.Comision}0'),
                  ],
                )
              : SizedBox(
                  width: 10,
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                //padding: EdgeInsets.only(top: 5.0),
                child: RaisedButton(
                  child: Text(
                    sComprar,
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: _bEntregaColonia
                      ? () {
                          if (RevisaUsuario(context)) if (_Cantidad == 0) {
                            vMensajeSys(context, sCantidadzero, 1);
                            //vMensajeSysIOS(context,"Cantidad en 0",1);
                          } else if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              if (!_Activa) {
                                PedidoMenu(user.id, widget.Data.id_menu,
                                    _Cantidad, txtCarritoNota.text);
                              } else {
                                PedidoMenuUbi(
                                    user.id,
                                    widget.Data.id_menu,
                                    _Cantidad,
                                    txtCarritoNota.text,
                                    _Direccion,
                                    _CP,
                                    _Colonia,
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                    _ComisionEnvioCompra.id_localidad,
                                    _ComisionEnvioCompra.id_ComisionEnvio,
                                    txtReferenciaEnvio.text);
                              }
                              Navigator.pop(context);
                            });
                          }
                        }
                      : null,
                ),
              ),
              //SizedBox(width: 20,),
              Flexible(
                child: SizedBox(
                  width: 0,
                ),
                flex: 3,
                fit: FlexFit.tight,
              ),
              Container(
                //padding: EdgeInsets.only(top: 5.0),
                child: RaisedButton(
                  child: Text(
                    sVpedido,
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: _bEntregaColonia
                      ? () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              if (!(bLogueado ?? false)) bLogueado = true;
                              if (!bLogueado) bLogueado = true;

                              Navigator.popAndPushNamed(
                                context,
                                '/BandejaUserPedido',
                              );
                            });
                          }
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container Ubicacion() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("Enviar a Ubicación"),
              TabFlexible,
              Switch(
                value: _Activa,
                onChanged: (value) {
                  setState(() {
                    //_Activa = value;
                    if (value)
                      TraeUbicacion();
                    else {
                      _Activa = value;
                      _Direccion = "";
                      _CP = "";
                      _Colonia = "";
                      vTraeComisionEnvioCompra(
                          widget.Data.id_restaurant, user.cp, user.Colonia);
                    }
                  });
                  //VerificaEstado(Restaurant.id_Restaurant, 1);
                },
              ),
            ],
          ),
          _Direccion != ""
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(
                  height: 0,
                ),
          _Direccion != ""
              ? Text(
                  "$_Direccion cp: $_CP",
                  style: TextStyle(color: Colors.black12),
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }

  Container Finalizar() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text('${sCantidad} :'),
              SizedBox(
                width: 20,
              ),
              StepperTouch(
                initialValue: 1,
                onChanged: (value) {
                  setState(() {
                    _Cantidad = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _ComisionEnvioCompra != null
              ? Row(
                  children: [
                    Text(_ComisionEnvioCompra.Descripcion),
                    Flexible(
                      child: SizedBox(
                        width: 0,
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Text('\$ ${_ComisionEnvioCompra.Comision}',
                        textAlign: TextAlign.left),
                  ],
                )
              : Text(
                  'No se puede Realizar envios a tu dirección',
                  style: EstiloLetraError,
                ),
          SizedBox(
            height: 10,
          ),
          _ComisionEnvioCompra?.Comision != null
              ? Row(
                  children: [
                    Text('${sTotal} :'),
                    //SizedBox(width: 20,),
                    Flexible(
                      child: SizedBox(
                        width: 0,
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Text(
                        '\$ ${(_Cantidad * widget.Data.Precio) + _ComisionEnvioCompra.Comision}0'),
                  ],
                )
              : SizedBox(
                  width: 10,
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: RaisedButton(
                  child: Text(
                    sComprar,
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: _bEntregaColonia
                      ? () {
                          if (RevisaUsuario(context)) if (_Cantidad == 0) {
                            vMensajeSys(context, sCantidadzero, 1);
                            //vMensajeSysIOS(context,"Cantidad en 0",1);
                          } else if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              if (!_Activa) {
                                PedidoMenu(user.id, widget.Data.id_menu,
                                    _Cantidad, txtCarritoNota.text);
                              } else {
                                PedidoMenuUbi(
                                    user.id,
                                    widget.Data.id_menu,
                                    _Cantidad,
                                    txtCarritoNota.text,
                                    _Direccion,
                                    _CP,
                                    _Colonia,
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                    _ComisionEnvioCompra.id_localidad,
                                    _ComisionEnvioCompra.id_ComisionEnvio,
                                    txtReferenciaEnvio.text);
                              }
                              Navigator.pop(context);
                            });
                          }
                        }
                      : null,
                ),
              ),
              //SizedBox(width: 20,),
              Flexible(
                child: SizedBox(
                  width: 0,
                ),
                flex: 3,
                fit: FlexFit.tight,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: RaisedButton(
                  child: Text(
                    sVpedido,
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: _bEntregaColonia
                      ? () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              if (!(bLogueado ?? false)) bLogueado = true;
                              if (!bLogueado) bLogueado = true;

                              Navigator.popAndPushNamed(
                                context,
                                '/BandejaUserPedido',
                              );
                            });
                          }
                        }
                      : null,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Stepper Wizard() {
    return Stepper(
        type: stepperType,
        physics: ScrollPhysics(),
        currentStep: _currentStep,
        onStepTapped: (Step) => tapped(Step),
        onStepContinue: continued,
        onStepCancel: cancel,
        steps: <Step>[
          Step(
            title: Text('Pedido'),
            content: Body(),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: Text('Ubicacion'),
            content: Ubicacion(),
            isActive: _currentStep >= 0,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: Text('Finalizar'),
            content: Finalizar(),
            isActive: _currentStep >= 0,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Body();
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

void vAddPedido(BuildContext context, BusquedaModel data) {
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
              child: AddPedido(
                Data: data,
              ),
            ),
          ],
        ));
      });
}
