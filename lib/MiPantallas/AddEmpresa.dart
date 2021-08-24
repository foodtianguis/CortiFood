import 'dart:convert';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/TraeInfoXcpModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'Restaurante/DatosRestaurante.dart';

class AddUserEmpresa extends StatefulWidget {
  AddUserEmpresa({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddUserEmpresa createState() => _AddUserEmpresa();
}

class _AddUserEmpresa extends State<AddUserEmpresa> {
  // UserModel _user;
  final _formKey = GlobalKey<FormState>();
  TraeInfoXcpModel traeInfoCP;

  String sValidaNombre = '';
  String sValidaNum = '';

  _sValida(String Tabla, String Campo, String Value) async {
    print("Valor: ${Value}");
    final result = await ValidaCampo(Tabla, Campo, Value);
    if (result != null)
      sValidaNombre = result;
    else
      sValidaNombre = '';
  }

  _sValidaNum(String Tabla, String Campo, String Value) async {
    String sValue;
    //sValue = Value.replaceAll(" ", "");
    sValue = Value;

    print("Valor: ${sValue}");
    final result = await ValidaCampo(Tabla, Campo, sValue);
    if (result != null)
      sValidaNum = result;
    else
      sValidaNum = '';
  }

  Future<void> fn_TraeDatosXcp(String sCP) async {
    //final response = await http.get("${sURL}Login/TraeInfoXCP/${sCP}",);
    final response = await http.get(
      CadenaConexion("Login/TraeInfoXCP/${sCP}"),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.body != '[]') {
        var jSon = json.decode(response.body);
        traeInfoCP = TraeInfoXcpModel.fromJson(jSon[0]);
        setState(() {
          ctrl.txtColonia.text = traeInfoCP.Nombre_Colonia;
          ctrl.txtCiudad.text = traeInfoCP.Nombre_municipio;
        });
      } else {
        traeInfoCP = null;
        ctrl.txtColonia.text = '';
        ctrl.txtCiudad.text = '';
      }
    } else {
      traeInfoCP = null;
      ctrl.txtColonia.text = '';
      ctrl.txtCiudad.text = '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrl.txtNewUser.text = '';
    ctrl.txtNewPass.text = '';
    ctrl.txtNewPassConf.text = '';
    ctrl.txtName.text = '';
    ctrl.txtApellido.text = '';
    ctrl.NoCel.text = '';
    ctrl.txtNumCel.text = '';
    ctrl.txtCP.text = '';
    ctrl.txtCalle.text = '';
    ctrl.txtCiudad.text = '';
    ctrl.txtColonia.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sNomApp),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sNomUserEmp),
                    style: EstiloLetraLB,
                    autofocus: true,
                    controller: ctrl.txtNewUser,
                    onChanged: (value) {
                      if (value != '') {
                        _sValida('Usuario', 'Nickname', value);
                        if (sValidaNombre != 'OK' && sValidaNombre != '') {
                          return sValidaNombre;
                        }
                      }
                      return null;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sNomUserEmp);
                      } else {
                        _sValida('Usuario', 'Nickname', value);
                        if (sValidaNombre != 'OK' && sValidaNombre != '') {
                          return sValidaNombre;
                        }
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 5.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sPassword),
                    style: EstiloLetraLB,
                    controller: ctrl.txtNewPass,
                    autofocus: true,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sPassword);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 5.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sPasswordConf),
                    style: EstiloLetraLB,
                    controller: ctrl.txtNewPassConf,
                    autofocus: true,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sPassword);
                      } else if (value != ctrl.txtNewPass.text) {
                        return 'Contraseñas no coinciden';
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: MiDivisor(),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sNombre),
                    style: EstiloLetraLB,
                    controller: ctrl.txtName,
                    autofocus: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sNombre);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sApellido),
                    style: EstiloLetraLB,
                    controller: ctrl.txtApellido,
                    autofocus: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sApellido);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sCelular),
                    keyboardType: TextInputType.phone,
                    style: EstiloLetraLB,
                    controller: ctrl.NoCel,
                    autofocus: true,
                    onChanged: (value) {
                      if (value != '') {
                        _sValidaNum('Usuario', 'NumCel', value);
                        if (sValidaNum != 'OK' && sValidaNum != '') {
                          return sValidaNum;
                        }
                      }
                      return null;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sCelular);
                      } else {
                        _sValidaNum('Usuario', 'NumCel', value);
                        if (sValidaNum != 'OK' && sValidaNum != '') {
                          return sValidaNum;
                        }
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sCP),
                    style: EstiloLetraLB,
                    controller: ctrl.txtCP,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sCP);
                      } else {
                        fn_TraeDatosXcp(value);
                        if (traeInfoCP != null) {
                          //ctrl.txtColonia.text = traeInfoCP.Nombre_Colonia;
                          //ctrl.txtCiudad.text = traeInfoCP.Nombre_municipio;
                        }
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sCP);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              sLabelGen(
                nIndex: 2,
                sTitulo: sCalle,
                txtController: ctrl.txtCalle,
              ),
              sLabelGen(
                nIndex: 2,
                sTitulo: sColonia,
                txtController: ctrl.txtColonia,
              ),
              sLabelGen(
                nIndex: 2,
                sTitulo: sCiudad,
                txtController: ctrl.txtCiudad,
              ),
              sLabelGen(
                nIndex: 2,
                sTitulo: sNumInt,
                txtController: ctrl.txtnumInt,
              ),
              sLabelGen(
                nIndex: 2,
                sTitulo: sNumExt,
                txtController: ctrl.txtnumExt,
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(top: 30),
                height: 60.0,
                //padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
                child: RaisedButton(
                  child: Text(
                    sSiguiente,
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  //padding: EdgeInsets.all(50.0),
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // Scaffold.of(context).showSnackBar(
                      //    SnackBar(content: Text('Processing Data')));
                      Navigator.pushNamed(context, '/AddDatoEmpresa');
                    } else {
                      print(_formKey.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddDatosEmpresa extends StatefulWidget {
  AddDatosEmpresa({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddDatosEmpresa createState() => _AddDatosEmpresa();
}

class _AddDatosEmpresa extends State<AddDatosEmpresa> {
  final _formKey = GlobalKey<FormState>();
  String sValida = '';

  _sValida(String Tabla, String Campo, String Value) async {
    final result = await ValidaCampo(Tabla, Campo, Value);
    setState(() {
      sValida = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sNomApp),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 50),
        child: FormDatosRestaurant(
          TipoAccion: 1,
        ),
      ),
    );
  }

  Future<void> postRestaurant(BuildContext context, String nick) async {
    final UserModel NewUsuario = await createEmpresa();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            //title: Text("From where do you want to take the photo?"),
            content: SingleChildScrollView(
              child: Text('Se creo Empresa: ${nick}'),
            ),
          );
        });
  }

  Future<UserModel> createEmpresa() async {
    String img64 = base64Encode(imageFile.readAsBytesSync());
    //final response = await http.post('${sURL}Login/AddRestaurant', body: {
    final response =
        await http.post(CadenaConexion('Login/AddRestaurant'), body: {
      'Nickname': ctrl.txtNewUser.text,
      'NumCel': ctrl.txtNumCel.text,
      'Pass': ctrl.txtNewPass.text,
      'ActivoUs': 'ACTIVO',
      'TipoUsuario': "2",
      'NombreUs': ctrl.txtName.text,
      'ApellidoUs': ctrl.txtApellido.text,
      'FechaRegUs': DateTime.now().toIso8601String(),
      //                                      Restaurant
      'Nombre': ctrl.txtNombreEmp.text,
      'Descripcion': ctrl.txtDescripcionEmp.text,
      'TipoCategoria': "0", //ctrl.txtTipoCategoriaEmp.text,
      'TipoRestaurant': ctrl.txtTipoRestaurantEmp.text,
      'Telefono': ctrl.txtTelefonoEmp.text,
      'Domicilio': ctrl.txtDomicilioEmp.text,
      'Sector': "0", //ctrl.txtSectorEmp.text,
      'DiasLaborales': ctrl.txtDiasLaboralesEmp.text,
      'horario': ctrl.txtHorarioEmp.text,
      'Activo': 'ACTIVO',
      'logo': img64, //sImagen(imageFile),
      'FechaReg': DateTime.now().toIso8601String(),
      'Latitud': dLatitud,
      'Longitud': dLongitud,
    });
    print("Estatus: ${response.statusCode}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      //final String sRespuesta = response.body;
      //return RestaurantModelFromJson(sRespuesta);
      var jSon = json.decode(response.body);
      return UserModel.fromJson(jSon[0]);
    } else {
      return null;
    }
  }
}
