

import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/login.dart';
import 'package:flutter/material.dart';

bool RevisaUsuario(BuildContext context){
  bool bResult = false;

  if (user != null)
    bResult = user.id > 0;

  if (!bResult) {
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
                    height: 400,
                    child: loginFloat(),
                  ),
                ],
              )
          );
        });

    if (user != null)
      bResult = user.id > 0;
  }

  return bResult;
}



void userVacio(){
  user = UserModel();
  user.id = 0;
  user.Nombre = 'INVITADO';
  user.NumCel = '0000000000';
  user.Pass = '123';
  user.Activo = 'ACTIVO';
  user.LoginFacebook = false;
  user.TipoUsuario = 5;
  user.Apellido = '';
  user.FechaNac = DateTime.parse('2000-01-01');
  user.FechaReg = DateTime.parse('2000-01-01');
  user.TipoPreferencia = 0;
  user.Calle = null;
  user.cp = null;
  user.Colonia = null;
  user.numExt = 0;
  user.numInt = 0;
  user.Ciudad = null;
  user.foto = '';
}