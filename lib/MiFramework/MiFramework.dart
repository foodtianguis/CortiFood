import 'dart:convert';
import 'dart:typed_data';

import 'package:dartxero/Maps/Map.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiPantallas/Restaurante/DatosRestaurante.dart';
import 'package:dartxero/MiPantallas/Usuario/DatosUsuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dartxero/MiFramework/MiLabeslGlobales.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart' as Acc;
import 'package:dartxero/login.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:dartxero/MiUtilidad/MiPhoto.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

MyPreferences _myPreferences = MyPreferences();

final String sVarLabels = ''; // Variable de Entorno para Acarrear Titulo

var condLabel = {
  0: UsersLabels(sTitulo: sVarLabels),
  1: PassLabels(sTitulo: sVarLabels),
  2: Row(),
  3: Column(),
  4: Stack(),
};

class sLabelGen extends StatelessWidget {
  final int nIndex;
  final String sTitulo;
  final TextEditingController txtController;

  const sLabelGen({Key key, this.nIndex, this.sTitulo, this.txtController})
      : super(key: key);

  //  this.sVarLabels = sTitulo;
  @override
  Widget build(BuildContext context) {
    return nIndex == 0
        ? UsersLabels(
            sTitulo: sTitulo,
            txtController: txtController) // ParaUsuarios o cualquier otro label
        : nIndex == 1
            ? PassLabels(
                sTitulo: sTitulo,
                txtController: txtController) // Para Contraseñas
            : nIndex == 2
                ? GenericLabels(
                    sTitulo: sTitulo,
                    txtController: txtController) // Para Contraseñas
                : GenericLabels(
                    sTitulo: sVarLabels, txtController: txtController);
    //condLabel[nIndex];
  }
}

class miBoton extends StatelessWidget {
  final String sTitle;

  //final Navigator nPrueba;
  const miBoton({Key key, this.sTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        "$sTitle",
        style: EstiloLetraBtn,
      ),
      color: ColorBoton,
      splashColor: splashBtn,
      disabledColor: disabledBth,
      onPressed: () {},
    );
  }
}

class MiDivisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Separador,
    );
  }
}

class RegistrarNuevo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.userPlus,
            color: ColorBtnTxt,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              sRegis,
              style: EstiloLetraBtn,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      color: ColorBoton,
      splashColor: splashBtn,
      disabledColor: disabledBth,
      onPressed: () {
        //_myPreferences.commit();
        Navigator.pushNamed(context, '/AddUser');
      },
    );
  }
}

class RegistrarNuevaEmpresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.business,
            color: ColorBtnTxt,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              sRegisEmpresa,
              style: EstiloLetraBtn,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      color: ColorBoton,
      splashColor: splashBtn,
      disabledColor: disabledBth,
      onPressed: () {
        //_myPreferences.commit();
        Navigator.pushNamed(context, '/AddUserEmpresa');
      },
    );
  }
}

class FacebookBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.facebook),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text(
              sRegisFace,
              style: EstiloFacebookBtn,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      color: ColorBtnFace,
      splashColor: splashBtn,
      disabledColor: disabledBth,
      onPressed: () {},
    );
  }
}

class SysAppDrawerVacio extends StatelessWidget {
  Drawer dw(BuildContext context) {
    return Drawer(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Container(
          width: double.maxFinite,
          child: DrawerHeader(
            decoration: BoxDecoration(color: ColorApp),
            child: Text(
              sNomApp,
              style: EstiloletrasTitulo,
            ),
          ),
        ),
        ListTile(
          leading: iInicSecion,
          title: Text(sInicSecion),
          onTap: () => {vIniciarSeccion(context)},
        ),
        ListTile(
          leading: iHlp,
          title: Text(sAyuda),
        ),
        ListTile(
          leading: iSalir,
          title: Text(sSalir),
          onTap: () => vSalir(),
        ),
        Flexible(
          child: SizedBox(
            height: 0,
          ),
          flex: 3,
          fit: FlexFit.tight,
        ),
        /*Container(
          child: Image.asset('Utilerias/Imagen/CANIRAC.png'),
          height: 100,
          width: 100,
          alignment: Alignment.bottomCenter,
        ),*/
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dw(context);
  }
}

class DrawerUser extends StatelessWidget {
  DecorationImage ImagenHeader() {
    return user != null
        ? (user.foto != null && user.foto != ""
            ? DecorationImage(
                image: Acc.Imagen(user.foto),
                alignment: Alignment.centerRight,
              )
            : DecorationImage(
                image: AssetImage(sLogoPerfilDefault),
                alignment: Alignment.centerRight))
        : DecorationImage(
            image: AssetImage(sLogoPerfilDefault),
            alignment: Alignment.centerRight);
  }

  Drawer dw(BuildContext context) {
    return Drawer(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Container(
          width: double.maxFinite,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: ColorApp,
              image: ImagenHeader(),
            ),
            child: Text(
              //bLogueado == true ? _myPreferences.user : user.Nickname,
              user != null ? user.Nickname : sNomApp,
              style: EstiloLetraDrawer,
            ),
          ),
        ),
        (user?.TipoUsuario ?? 0) == 1
            ? ListTile(
                leading: iMDs,
                title: Text(sMiDatos),
                onTap: () => vDatosUsuario(context, 2),
              )
            : null,
        /*ListTile(
          leading: iMsj,
          title: Text(sMensaje),
        ),*/
        ListTile(
          leading: iHlp,
          title: Text(sAyuda),
        ),
        ListTile(
          leading: iCerrarSecion,
          title: Text(sCerrarSecion),
          onTap: () => {vCerrarSeccion(context)},
        ),
        ListTile(
          leading: iSalir,
          title: Text(sSalir),
          onTap: () => vSalir(),
        ),
        //Flexible(child: SizedBox(height: 200,)),
        //Flexible(child: SizedBox(height: 0,),flex: 3,fit: FlexFit.tight,),
        //Container(child: Image.asset('Utilerias/Imagen/CANIRAC.png'),height: 100,width: 100,alignment: Alignment.bottomCenter,),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dw(context);
  }
}

class GetCheckValue extends StatefulWidget {
  @override
  GetCheckValueState createState() {
    return new GetCheckValueState();
  }
}

class GetCheckValueState extends State<GetCheckValue> {
  MyPreferences _myPreferences = MyPreferences();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
          Checkbox(
            checkColor: ColorBtnTxt,
            value:
                _myPreferences.automatic == Null ? false : _myPreferences.automatic,
              onChanged: (val) {
                setState(() {
                  //timeDilation != 1.0;
                  timeDilation = val ? 5.0 : 1.0;
                  print(val.toString());
                  _myPreferences.automatic =
                      val == null ? _myPreferences.automatic : val;
                  print(val.toString());
                  //  _myPreferences.commit();
                  _isChecked = val;
                  bRecorUser = _isChecked;
                });
              },
            ),
            Text(
              sRecUser,
              style: EstiloLetraLB,
            ),
          ]
        )
    );
  }
}

class UbicacionBtn extends StatelessWidget {
  final LatLng llTraeUbica;

  const UbicacionBtn({Key key, this.llTraeUbica}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: iUbica,
        color: ColorBoton,
        splashColor: splashBtn,
        disabledColor: disabledBth,
        padding: EdgeInsets.only(left: 130.0, right: 130.0),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  content: SingleChildScrollView(
                      child: ListBody(
                    children: [
                      Container(
                        child: MapSample(
                          llTraeUbica: llTraeUbica,
                        ),
                        height: 300,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Text('Aceptar'),
                        onTap: () => Navigator.pop(context),
                      )
                    ],
                  )),
                );
              });
        });
  }
}
