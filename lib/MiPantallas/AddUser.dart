import 'dart:convert';
import 'package:dartxero/Maps/MapFloat.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiFramework/miFechas.dart';
import 'package:dartxero/MiModel/TraeInfoXcpModel.dart';
import 'package:dartxero/MiModel/UbicacionModel.dart';
import 'package:dartxero/MiUtilidad/MiPhoto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class AddDatosUsers extends StatefulWidget {
  AddDatosUsers({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddDatosUsers createState() => _AddDatosUsers();
}

class _AddDatosUsers extends State<AddDatosUsers> {
  // UserModel _user;
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
        title: Text(
          sNomApp,
          style: EstiloletrasTitulo,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 30, right: 30),
        child: Form(
          key: _formKey,
          //padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: ListView(
            children: <Widget>[
              PhotoPreviewScreen(
                sTraeImagen: '',
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sNomUser),
                    style: EstiloLetraLB,
                    controller: ctrl.txtNewUser,
                    onChanged: (value) {
                      _sValida('Usuario', 'Login', value);
                      if (sValida != 'OK') {
                        return sValida;
                      } else {
                        ctrl.NoCel.text = ctrl.txtNewUser.text;
                      }
                      return null;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sNomUser);
                      } else {
                        _sValida('Usuario', 'Login', value);
                        if (sValida != 'OK') {
                          return sValida;
                        } else {
                          ctrl.NoCel.text = ctrl.txtNewUser.text;
                        }
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sPassword),
                    style: EstiloLetraLB,
                    controller: ctrl.txtNewPass,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sPassword);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sPasswordConf),
                    style: EstiloLetraLB,
                    controller: ctrl.txtNewPassConf,
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
                child: FechasSys(),
                padding: EdgeInsets.only(top: 15.0),
              ),
              /*Container(
                child: Anio(),
                padding: EdgeInsets.only(top: 15.0),
              ),*/
              Container(
                width: 20,
                padding: EdgeInsets.only(top: 15),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(top: 10),
                height: 40.0,
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
                      Navigator.pushNamed(context, '/AddDomicilioUsers');
                    } else {
                      print(_formKey.toString());
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddDomicilioUsers extends StatefulWidget {
  AddDomicilioUsers({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddDomicilioUsers createState() => _AddDomicilioUsers();
}

class _AddDomicilioUsers extends State<AddDomicilioUsers> {
  // UserModel _user;
  final _formKey = GlobalKey<FormState>();
  TraeInfoXcpModel traeInfoCP;
  String sValida = '';
  LocationData currentLocation;
  double _Latitud;
  double _Longitud;
  //UbicacionModel Ubicacion;
  bool _TieneUbicacion;
  _sValida(String Tabla, String Campo, String Value) async {
    final result = await ValidaCampo(Tabla, Campo, Value);
    setState(() {
      sValida = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      ctrl.txtName.text = '';
      ctrl.txtApellido.text = '';
      //ctrl.NoCel.text = '';
      ctrl.txtCalle.text = '';
      ctrl.txtCP.text = '';
      ctrl.txtColonia.text = '';
      ctrl.txtnumInt.text = '';
      ctrl.txtnumExt.text = '';
      ctrl.txtReferenciaEnvio.text = '';

      _TieneUbicacion = false;
    });
  }

  void vMapFloatlcl(BuildContext context) {
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
                height: 430,
                child: Column(
                  children: [
                    MapFloat(),
                    Flexible(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    MaterialButton(
                        color: ColorApp,
                        textColor: ColorFondoApp,
                        child: Text(
                          sConfirma,
                          style: EstiloLetraBtn,
                        ),
                        onPressed: () {
                          setState(() {
                            _TieneUbicacion = UbicacionUsuario != null;
                            if (_TieneUbicacion) {
                              ctrl.txtCalle.text = UbicacionUsuario.Ubicacion;
                              ctrl.txtCP.text = UbicacionUsuario.UbicacionCP;
                              ctrl.txtColonia.text = UbicacionUsuario.Colonia;
                              _Latitud = UbicacionUsuario.Latitud;
                              _Longitud = UbicacionUsuario.Longitud;
                            }
                          });
                          Navigator.of(context).pop();
                          //Navigator.pop(context);
                        })
                  ],
                ),
              ),
            ],
          ));
        });
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
      body: Container(
        padding: EdgeInsets.only(top: 0, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sNombre),
                    style: EstiloLetraLB,
                    controller: ctrl.txtName,
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
                    decoration: InputDecoration(hintText: sCelular),
                    keyboardType: TextInputType.phone,
                    style: EstiloLetraLB,
                    controller: ctrl.NoCel,
                    enabled: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sCelular);
                      } else {
                        _sValida('Usuario', 'NumCel', value);
                        if (sValida != 'OK' && sValida != '') {
                          return sValida;
                        }
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Row(
                children: [
                  Expanded(
                    //width: 300,
                    child: Container(
                      child: sLabelGen(
                        nIndex: 2,
                        sTitulo: sDomicilio,
                        txtController: ctrl.txtCalle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 30,
                    child: MaterialButton(
                      color: ColorApp,
                      textColor: ColorLabel,
                      child: iUbicaSys,
                      padding: EdgeInsets.all(0),
                      shape: CircleBorder(),
                      onPressed: () {
                        setState(() {
                          vMapFloatlcl(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sCP),
                    style: EstiloLetraLB,
                    controller: ctrl.txtCP,
                    enabled: false,
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
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sColonia),
                    style: EstiloLetraLB,
                    controller: ctrl.txtColonia,
                    enabled: false,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sColonia);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: TextFormField(
                    decoration: InpDecoTxt(sReferencia),
                    style: EstiloLetraLB,
                    controller: ctrl.txtReferenciaEnvio,
                    validator: (value) {
                      if (value.isEmpty) {
                        return sMensajeErrorComp(sReferencia);
                      }
                      return null;
                    }),
                padding: EdgeInsets.only(top: 10.0),
              ),
              /*sLabelGen(
                nIndex: 2,
                sTitulo: sColonia,
                txtController: ctrl.txtColonia,
              ),
              sLabelGen(
                nIndex: 2,
                sTitulo: sCiudad,
                txtController: ctrl.txtCiudad,
              ),*/
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
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                height: 50.0,
                //padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
                child: RaisedButton(
                    child: Text(
                      sConfirma,
                      style: EstiloLetraBtn,
                    ),
                    color: ColorBoton,
                    //padding: EdgeInsets.all(50.0),
                    splashColor: splashBtn,
                    disabledColor: disabledBth,
                    onPressed: (_TieneUbicacion) ? () => OnPressed() : null),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  void OnPressed() async {
    print('Entrar');
    if (_formKey.currentState.validate()) {
      //postUsuario(context);
      final UserModel NewUsuario = await createUser();
      print(NewUsuario.toString());
      setState(() {
        user = NewUsuario;
        dUsuarioGLB = NewUsuario;
      });
      if (user != null) {
        postUsuario(context, user.Nickname);
        Navigator.pushReplacementNamed(context, '/BandejaUs');
      }
    } else {
      print(_formKey.toString());
    }
  }

  Future<void> postUsuario(BuildContext context, String nick) async {
    // final UserModel NewUsuario = await createUser();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            //title: Text("From where do you want to take the photo?"),
            content: SingleChildScrollView(
              child: Text('Se creo usuario: ${nick}'),
            ),
          );
        });
  }

  Future<UserModel> createUser() async {
    String img64 = '';
    if (imageFile != null) img64 = base64Encode(imageFile.readAsBytesSync());
    //final response = await http.post('${sURL}Login/AddUser',
    final response = await http.post(CadenaConexion('Login/AddUser'), body: {
      'Nickname': ctrl.txtNewUser.text,
      'NumCel': ctrl.txtNumCel.text,
      'Pass': ctrl.txtNewPass.text,
      'Activo': 'ACTIVO',
      'LoginFacebook': bLoguinFacebook.toString(),
      'TipoUsuario': "1",
      'Nombre': ctrl.txtName.text,
      'Apellido': ctrl.txtApellido.text,
      'FechaNac':
          (sFechaNacCont != null) ? sFechaNacCont.toIso8601String() : '',
      'FechaReg': DateTime.now().toIso8601String(),
      'TipoPreferencia': ctrl.txtTipoPreferencia.text,
      'Calle': ctrl.txtCalle.text,
      'cp': ctrl.txtCP.text,
      'Colonia': ctrl.txtColonia.text,
      'numExt': ctrl.txtnumExt.text,
      'numInt': ctrl.txtnumInt.text,
      'Ciudad': ctrl.txtCiudad.text,
      'foto': img64, //sImagen(imageFile),
      'Latitud': UbicacionUsuario.Latitud.toString(),
      'Longitud': UbicacionUsuario.Longitud.toString(),
      'Referencia': ctrl.txtReferenciaEnvio.text
    });

    //List<dynamic> body = jsonDecode(response.body);
    //List<UserModel> vUserModel = body.map((dynamic item) => UserModel.fromJson(item),).toList();//
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jSon = json.decode(response.body);
      print("Json: ${jSon.toString()}");
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return UserModel.fromJson(jSon[0]);
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      return null;
    }
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
}
