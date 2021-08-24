import 'package:dartxero/MiFramework/Base/BaseUser.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miMenu.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiPantallas/BandejaUsuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BusquedaDetalle extends StatefulWidget {
  final BusquedaModel Busqueda;

  const BusquedaDetalle({Key key, this.Busqueda}) : super(key: key);
  @override
  BusquedaDetalleState createState() => BusquedaDetalleState();
}

class BusquedaDetalleState extends State<BusquedaDetalle>{

  @override
  Widget build(BuildContext context) {
    return //BaseUser(sTitulo: sNomApp,nOpcion: 1,busqueda: widget.Busqueda,);
    BandejaUsuario(nIndex: 0,nOpcion: 1,busqueda: widget.Busqueda,);

    /*return Column(
      children: [
        BaseUser(sTitulo: sNomApp,nOpcion: 1,busqueda: widget.Busqueda,),
        //Container(child: miMenu(id_Restaurant: widget.Busqueda.id_restaurant,),),
      ],
    );*/
  }
}