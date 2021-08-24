import 'dart:async';
import 'dart:convert';
import 'package:dartxero/Api/Api.dart';
import 'package:dartxero/Listas/ListadosUso.dart';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/Notificaciones.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/GridInicioModel.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiPantallas/BandejaRestaurant.dart';
import 'package:dartxero/MiPantallas/BandejaUsuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:splashscreen/splashscreen.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:dartxero/MiPantallas/Grids/GridInicio.dart';

const API_KEY = "AIzaSyC0oJ2-IUW_yU9mNU85lu_pq0mMVAFyLTI";

class Bandeja extends StatefulWidget {
  _Bandeja createState() => _Bandeja();
}

class _Bandeja extends State<Bandeja> {
  MyPreferences _myPreferences = MyPreferences();
  String sMensaje = '';
  int _nNotiRest = 0;
  int _nNotiUser = 0;

  Future<void> Login() async {
    try {
      if (_myPreferences.automatic == true) {
        final response = await http.get(
          //"${sURL}Login/In/${_myPreferences.user.replaceAll(' ', '')}/${_myPreferences.password}",
          CadenaConexion(
              "Login/In/${_myPreferences.user.replaceAll(' ', '')}/${_myPreferences.password}"),
        );
        if (response.statusCode == 201 || response.statusCode == 200) {
          var jSon = json.decode(response.body);
          dUsuarioGLB = jSon;
          if (mounted) {
            setState(() {
              IniRestaurant = false;
              user = UserModel.fromJson(jSon[0]);
              /*TokenNotificaciones token = TokenNotificaciones();
              token.initToken(user.id);

              token.mensaje.listen((event) {
                if (event == 'Restaurant'){
                  _nNotiRest = 1;
                  //Navigator.pushReplacementNamed(context, '/BandejaRestPedido');
                } else if (event == 'NotifiUser') {
                  _nNotiUser = 2;
                }
              });*/
            });
          }
        } else {
          if (mounted) {
            setState(() {
              sMensaje = sMensajeErrorLoguin;
              bLogueado = false;
              user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
            });
          }
        }
      } else {
        print('No tiene usuario guardado');
        bLogueado = false;
        user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
      }
    } on Exception catch (ex) {
      print('Error: ${ex.toString()}');
      bLogueado = false;
      ;
      user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
    }
    //return db;
  }

  @override
  Widget build(BuildContext context) {
    return ((user?.TipoUsuario ?? 0) == 1
        ? BandejaUsuario(
            nIndex: _nNotiUser,
          )
        : (user?.TipoUsuario ?? 0) == 2
            ? BandejaRestaurant(
                nIndex: _nNotiRest,
              )
            : Scaffold(
                appBar: AppBar(
                  /*title: Text(sNomApp),*/ title: Text(
                    sNomApp,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: ColorBtnTxt,
                    ),
                  ),
                  actions: <Widget>[
                    iBusqueda(context),
                  ],
                ),
                drawer: dwInicio,
                body: Column(
                  children: [
                    /*Container(
                height: 150,
                child: Cartelon(),
                //color: Colors.purpleAccent,
              ),*/
                    Container(
                      height: 5,
                    ),
                    Expanded(child: GridInicio())
                  ],
                ),
              ));

    /*SplashScreen(
        seconds: 5,
        navigateAfterSeconds: ((user?.TipoUsuario ?? 0) == 1
            ? BandejaUsuario(nIndex: _nNotiUser,)
            : (user?.TipoUsuario ?? 0) == 2
                ? BandejaRestaurant(nIndex: _nNotiRest,)
                : Scaffold(appBar: AppBar(title: Text(sNomApp),),drawer: vDrawerLogin(),)
        ),
        backgroundColor: ColorApp,
        image: Image.asset(
          //'Utilerias/Imagen/User.png',
          'Utilerias/Imagen/AskmeInicio.png',
          //'Utilerias/Imagen/Askme6.png',
          height: 250,
          width: 250,
        ),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.green[100]);*/
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      dwInicio = SysAppDrawerVacio().dw(context);
    });
    IniRestaurant = false;
    if ((bLogueado ?? false) == false) {
      _myPreferences.init().then((value) {
        //setState(() {
        _myPreferences = value;
        Login();
        //});
      });
    }
  }
}
