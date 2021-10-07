import 'dart:convert';

import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiUtilidad/stepper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddCarrito extends StatefulWidget {
  final BusquedaModel Data;

  const AddCarrito({Key key, this.Data}) : super(key: key);
  @override
  AddCarritoState createState() => AddCarritoState();
}

class AddCarritoState extends State<AddCarrito> {
  final _formKey = GlobalKey<FormState>();

  int _Cantidad;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _Cantidad = 1;
      txtCarritoNom.text = widget.Data.menuNombre;
      txtCarritoDesc.text = widget.Data.menuDescripcion;
      txtCarritoNota.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: widget.Data.menufoto != null
                ? Image(
                    height: 120.0,
                    width: 130.0,
                    image: Imagen(widget.Data.menufoto),
                  )
                : Container(
                    child: Center(
                        child: Text(
                      'No Hay Foto',
                    )),
                    height: 120.0,
                    width: 130.0,
                  ),
          ),
          SizedBox(
            width: 10,
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(sCantidad2Pt),
              SizedBox(
                width: 20,
              ),
              StepperTouch(
                initialValue: 1,
                onChanged: (int value) => _Cantidad = value,
              ),
            ],
          ),
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
              Container(
                //padding: EdgeInsets.only(top: 5.0),
                child: RaisedButton(
                  child: Text(
                    "Agregar",
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: () {
                    if (_Cantidad == 0) {
                      vMensajeSys(context, sCantidadzero, 1);
                      //vMensajeSysIOS(context,"Cantidad en 0",1);
                    } else if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        PostCarrito(widget.Data.id_menu, _Cantidad, user.id,
                            txtCarritoNota.text);
                        Navigator.pop(context);
                      });
                      //Navigator.pushReplacementNamed(context, '/BandejaRest');
                    }
                  },
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 50,
                ),
              ),
              Container(
                //padding: EdgeInsets.only(top: 5.0),
                child: RaisedButton(
                  child: Text(
                    "Ver Carrito",
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        Navigator.popAndPushNamed(
                          context,
                          '/BandejaUserCarrito',
                        );
                      });
                      //Navigator.pushReplacementNamed(context, '/BandejaRest');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> PostCarrito(
    int id_menu, int Cantidad, int id_usuario, String sDescripcion) async {
  /*final repose = (sDescripcion != "") ?
      await post("${sURL}Carrito/InsertarCarrito/${id_menu}/${Cantidad}/${id_usuario}/${sDescripcion}")
      :await post("${sURL}Carrito/InsertarCarritoSin/${id_menu}/${Cantidad}/${id_usuario}");*/
  final repose = (sDescripcion != "")
      ? await post(CadenaConexion(
          "Carrito/InsertarCarrito/${id_menu}/${Cantidad}/${id_usuario}/${sDescripcion}"))
      : await post(CadenaConexion(
          "Carrito/InsertarCarritoSin/${id_menu}/${Cantidad}/${id_usuario}"));

  if (repose.statusCode == 200 || repose.statusCode == 201) {
  } else {
    throw Exception("Fallo!");
  }
}

void vAddCarrito(BuildContext context, BusquedaModel data) {
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
              child: AddCarrito(
                Data: data,
              ),
            ),
          ],
        ));
      });
}
