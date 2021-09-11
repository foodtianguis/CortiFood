import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartxero/MiFramework/MiAccionLogin.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/ImagenModel.dart';
import 'package:dartxero/MiModel/TraeInfoXcpModel.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/MiPantallas/BandejaRestaurant.dart';
import 'package:dartxero/MiPantallas/BandejaUsuario.dart';
import 'package:dartxero/MiPantallas/Restaurante/DrawerRestaurant.dart';
import 'package:dartxero/MiPantallas/Restaurante/SearchColonia.dart';
import 'package:dartxero/MiUtilidad/MiSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'dart:io';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'VentanasMensajes/MensajesSys.dart';

void vSalir() {
  exit(0);
}

void vCerrarSeccion(BuildContext context){
  MyPreferences _myPreferences = MyPreferences();

  ctrl.txtPass.text = _myPreferences.automatic == true
      ? _myPreferences.password
      : '';
  ctrl.txtUser.text =
  _myPreferences.automatic == true ? _myPreferences.user : '';
  //user = json.decode(sJsonVacio.trim());
  //user = UserModel.fromJson(json.decode(sJsonVacio.trim()[0]));
  userVacio();
  if (user.id == 0){
    bLogueado = true;
    Navigator.pushNamed(context, '/BandejaUs');
  }
}

void vIniciarSeccion(BuildContext context){
  MyPreferences _myPreferences = MyPreferences();
  if (_myPreferences == null) {
    _myPreferences.init().then((value) {
        _myPreferences = value;
        //login.createState();
    });
  }

  ctrl.txtPass.text = _myPreferences.automatic == true
      ? _myPreferences.password
      : '';
  ctrl.txtUser.text =
  _myPreferences.automatic == true ? _myPreferences.user : '';
  Navigator.pushNamed(context, '/loginPage');
}

class vDrawerLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ((user?.TipoUsuario ?? 0) == 1 ? DrawerUser():
    (user?.TipoUsuario ?? 0) == 2 ? DrawerRest() :
    SysAppDrawerVacio());
  }
}

String sRegresaMes(int iMes){
  String sMes;
  switch (iMes) {
    case 1: sMes = sEnero;
    break;
    case 2: sMes = sFebrero;
    break;
    case 3: sMes = sMarzo;
    break;
    case 4: sMes = sAbril;
    break;
    case 5: sMes = sMayo;
    break;
    case 6: sMes = sJunio;
    break;
    case 7: sMes = sJulio;
    break;
    case 8: sMes = sAgosto;
    break;
    case 9: sMes = sSeptiembre;
    break;
    case 10: sMes = sOctubre;
    break;
    case 11: sMes = sNoviembre;
    break;
    case 12: sMes = sDiciembre;
    break;
  }
  return sMes;
}

String Validacion(String value) {
  switch (iTipoVal) {
    case 0:
      if (value.isEmpty) {
        return 'Ingrese Nombre de Usuario';
      }
      break;
    case 1:
      if (value.isEmpty) {
        return 'Confirme Contraseña';
      } else if (value != ctrl.txtNewPass) {
        return 'Contraseñas no coinciden';
      }
      break;
    case 2:
      if (value.isEmpty) {
        return 'Ingrese Contraseña';
      }
      break;
  }
}

Future<String> ValidaCampo(String Tabla, String Campo, String Value) async {
  //final response = await http.get("${sURL}Login/ValidaCampoUser/${Tabla}/${Campo}/${Value}",);
  final response = await http.get(CadenaConexion("Login/ValidaCampoUser/${Tabla}/${Campo}/${Value}"),);
  var Result = json.decode(response.body);
  print(Result[0]);
  if (Result.length != 0) {
    if (Result[0] == '0') {
      return 'OK';
    }else{
      if (Result[0] == '1') {
        return 'El Dato ya existe!';
      }
    }
  } else {
    return 'Error en la Conexion';
  }
}

String sMensajeErrorComp(String Campo){
  return sErrorIngrese + Campo;
}

ImageProvider Imagen(String BASE64_STRING) {
  if (BASE64_STRING == null)
    BASE64_STRING = SinImagen;
  Uint8List bytes;
  //Image img = Image.memory(base64Decode(BASE64_STRING));
  try {
    bytes = base64Decode(BASE64_STRING);
  }
  on Exception catch (ex){
    bytes = base64Decode(SinImagen);
  }
  return MemoryImage(bytes);
}

ImageProvider ImagenMenu(int id_menu)  {
  ImageMenuStr(id_menu);

  Uint8List bytes = base64Decode(BASE64_STRING != null? BASE64_STRING : SinImagen);
  return MemoryImage(bytes);
}

Future<String> ImageMenuStr(int id_menu) async {
  //final response = await http.get('${sURL}Menu/ViewPlatillosImagen/${id_menu}',);
  final response = await http.get(CadenaConexion('Menu/ViewPlatillosImagen/${id_menu}'));
  if (response.statusCode == 201 || response.statusCode == 200) {
    var Json = json.decode(response.body);
    ImagenModel Imagen = ImagenModel.fromJson(Json[0]);
    BASE64_STRING = Imagen?.foto?? '' != '' ? Imagen.foto : SinImagen;
  }else
    BASE64_STRING = SinImagen;
}

class Login extends StatefulWidget{
  @override
  _Login createState() => _Login();

}

class _Login extends State<Login>{
  MyPreferences _myPreferences = MyPreferences();
  _Login(){
    if (_myPreferences == null) {
      _myPreferences.init().then((value) {
        setState(() {
          _myPreferences = value;
          //_Login(_myPreferences.user, _myPreferences.password);
        });
      });
    }
    if(_myPreferences.automatic == true) {
      vLogin(_myPreferences.user, _myPreferences.password);
    }
  }

  void Entrar(){
    if(_myPreferences.automatic == true) {
      vLogin(_myPreferences.user, _myPreferences.password);
    }
  }

  Future<void> vLogin(String sUser, String sPass) async {
    String sMensaje;
    try {
      //final response = await http.get("${sURL}Login/In/${sUser}/${sPass}",);
      final response = await http.get(CadenaConexion("Login/In/${sUser}/${sPass}"));
      if (response.statusCode == 201 || response.statusCode == 200) {
        var jSon = json.decode(response.body);
        user = UserModel.fromJson(jSon[0]);
        bLogueado = true;
        sMensaje = 'Listo';
        //if (dUsuarioGLB.length == 0) {
      } else {
        sMensaje = sMensajeErrorLoguin;
        bLogueado = false;
        user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);

      }
    }
    on Exception catch (ex){
      bLogueado = false;
      user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
    }

    if (user.TipoUsuario == 1) {
      bLogueado = true;
      Navigator.pushReplacementNamed(context, '/BandejaUser');
      // Navigator.pop(context);
    } else if (user.TipoUsuario == 2) {
      Navigator.pushNamed(context, '/BandejaRest');
    }
    //return sMensaje;
  }

  @override
  Widget build(BuildContext context) {
    return user.TipoUsuario == 1 ? BandejaUsuario() : BandejaRestaurant();
  }
}

void vMsjError(BuildContext context, String sMsj){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: SingleChildScrollView(
              child: ListBody(
                children: [Container(child: Row(
                  children: [
                    Container(child: iError,padding: EdgeInsets.all(10.0),),
                    Container(child:Text(sMsj,textAlign: TextAlign.left,),padding: EdgeInsets.all(10.0),),
                  ],
                ), ),
                  SizedBox(height: 20, ),
                  GestureDetector(child: Text('Listo'),
                    onTap: () => Navigator.pop(context),
                  )
                ],
              )
          ),
        );
      });
}

String sImagen(File imagenFile){
  if (imagenFile != null) {
  List<int> imageBytes = imagenFile.readAsBytesSync();
  return base64.encode(imageBytes);
  } else {
    return '';
  }
}

GestureDetector slink(String sTitulo){
  BuildContext context;
  return GestureDetector(
      child: Text(sTitulo, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
      onTap: () {
        vMensajeSys(context, "Click", 4);
      }
  );
}

Text Link(String sEtiqueta){
  return Text(sEtiqueta,style: EstiloLink,);
}

IconButton iBusqueda(BuildContext context){
  return IconButton(
      icon: iSrch,
      color: ColorBtnTxt,
      onPressed:() {
        showSearch(context: context,delegate: Search());
      });
}

IconButton iBusquedaCol(BuildContext context){
  return IconButton(
      icon: iSrch,
      color: ColorBtnTxt,
      onPressed:() {
        showSearch(context: context,delegate: SearchColonia());
      });
}