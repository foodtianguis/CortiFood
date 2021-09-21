import 'dart:convert';
import 'dart:async';
import 'package:dartxero/MiFramework/MiAccionLogin.dart';
import 'package:dartxero/MiFramework/Notificaciones.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/MiPantallas/Restaurante/DrawerRestaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'MiFramework/RecordarDatos.dart';
import 'MiFramework/miRestaurant.dart';

class loginPage extends StatefulWidget {
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String sMensaje = '';
  MyPreferences _myPreferences = MyPreferences();
  BuildContext Context;

  //Future<String> s = rUser('','',2, false);
  Future<List> _Login(String sUser, String sPass) async {
    try{
    //final response = await http.get("${sURL}Login/In/${sUser.replaceAll(' ', '')}/${sPass}",)
    final response = await http.get(CadenaConexion("Login/In/${sUser.replaceAll(' ', '')}/${sPass}"));
    var jSon = json.decode(response.body);
    dUsuarioGLB = jSon;
    user = UserModel.fromJson(jSon[0]);

    if (user == null) {
      setState(() {
        sMensaje = sMensajeErrorLoguin;
        bLogueado = false;
      });
    } else {
      TokenNotificaciones token = TokenNotificaciones();
      token.initToken(user.id);

      if (user.TipoUsuario == 1) {
        bLogueado = true;
        dwInicio = DrawerUser().dw(context);
        Navigator.pushReplacementNamed(context, '/BandejaUs');
      } else if (user.TipoUsuario == 2) {
        //bLogueado = true;
        Restaurant = await RestaurantView(user.id);
        Navigator.pushReplacementNamed(context, '/BandejaRest');
      }
    }
    }catch (ex) {
      bLogueado = false;
      sMensaje = "Error: Revisar Conexión";
    }
    if (sMensaje != '')
      vMsjError(Context, sMensaje);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(sNomApp,style: EstiloletrasTitulo,),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: ListView(
            children: <Widget>[
              Icon(FontAwesomeIcons.userNinja, color: ColorApp,size: 200,),
              SizedBox(height: 20,),
              sLabelGen(
                nIndex: 0,
                sTitulo: sNomUser,
                txtController: ctrl.txtUser,
              ),
              sLabelGen(
                nIndex: 1,
                sTitulo: sPassword,
                txtController: ctrl.txtPass,
              ),
              GetCheckValue(),
              RaisedButton(
                child: Text(
                  sEntrar,
                  style: EstiloLetraBtn,
                ),
                color: ColorBoton,
                splashColor: splashBtn,
                disabledColor: disabledBth,
                onPressed: () {
                  _myPreferences.automatic = bRecorUser == Null ? false : bRecorUser;
                  if (bRecorUser == true) {
                    _myPreferences.user = ctrl.txtUser.text;
                    _myPreferences.password = ctrl.txtPass.text;

                    Context = context;
                    _myPreferences.commit();
                  } else {
                    _myPreferences.user = '';
                    _myPreferences.password = '';
                  }

                  _Login(ctrl.txtUser.text, ctrl.txtPass.text);
                },
              ),
              //   miBoton(sTitle: 'Entrar'),
              MiDivisor(),
              RegistrarNuevo(),
              RegistrarNuevaEmpresa(),
              //FacebookBtn(),
            ],
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sMensaje = '';
      userVacio();
      dwInicio = SysAppDrawerVacio().dw(context);
    });
    _myPreferences.init().then((value) {
      setState(() {
        _myPreferences = value;
      });
    });
  }
}

class loginFloat extends StatefulWidget {
  _loginFloatState createState() => _loginFloatState();
}

class _loginFloatState extends State<loginFloat> {
  String sMensaje = '';
  MyPreferences _myPreferences = MyPreferences();
  BuildContext Context;

  //Future<String> s = rUser('','',2, false);
  Future<List> _Login(String sUser, String sPass) async {
    try{
      //final response = await http.get("${sURL}Login/In/${sUser.replaceAll(' ', '')}/${sPass}",);
      final response = await http.get(CadenaConexion("Login/In/${sUser.replaceAll(' ', '')}/${sPass}"));
      var jSon = json.decode(response.body);
      dUsuarioGLB = jSon;
        user = UserModel.fromJson(jSon[0]);

      if (user == null) {
        setState(() {
          sMensaje = sMensajeErrorLoguin;
          bLogueado = false;
        });
      } else {
        TokenNotificaciones token = TokenNotificaciones();
        token.initToken(user.id);
        if (user.TipoUsuario == 1) {
          bLogueado = true;
          Navigator.pushReplacementNamed(context, '/BandejaUs');
          //print('========================Entra el usuario=======================');
          //Navigator.pop(context);
        } else if (user.TipoUsuario == 2) {
          //bLogueado = true;
          Restaurant = await RestaurantView(user.id);
          dwInicio = DrawerRest() as Drawer;
          Navigator.pushNamed(context, '/BandejaRest');
        }
      }
    }catch (ex) {
      bLogueado = false;
      sMensaje = "Error: Revisar Conexión";
    }
    if (sMensaje != '')
      vMsjError(Context, sMensaje);
  }

  Container Flotante(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: ListView(
        children: <Widget>[
          //Icon(FontAwesomeIcons.userNinja, color: Colors.grey,size: 200,),
          Text('Primero, Inicia Secion...', style: Estiloletrasbdj,),
          Flexible(child: SizedBox(height: 10,)),
          sLabelGen(
            nIndex: 0,
            sTitulo: sNomUser,
            txtController: ctrl.txtUser,
          ),
          sLabelGen(
            nIndex: 1,
            sTitulo: sPassword,
            txtController: ctrl.txtPass,
          ),
          GetCheckValue(),
          RaisedButton(
            child: Text(
              sEntrar,
              style: EstiloLetraBtn,
            ),
            color: ColorBoton,
            splashColor: splashBtn,
            disabledColor: disabledBth,
            onPressed: () {
              _myPreferences.automatic = bRecorUser == Null ? false : bRecorUser;
              if (bRecorUser == true) {
                _myPreferences.user = ctrl.txtUser.text;
                _myPreferences.password = ctrl.txtPass.text;

                Context = context;
                _myPreferences.commit();
              } else {
                _myPreferences.user = '';
                _myPreferences.password = '';
              }

              _Login(ctrl.txtUser.text, ctrl.txtPass.text);
            },
          ),
          //   miBoton(sTitle: 'Entrar'),
          MiDivisor(),
          RegistrarNuevo(),
          //RegistrarNuevaEmpresa(),
          //FacebookBtn(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flotante(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sMensaje = '';
      userVacio();
    });
    _myPreferences.init().then((value) {
      setState(() {
        _myPreferences = value;
      });
    });
  }
}

