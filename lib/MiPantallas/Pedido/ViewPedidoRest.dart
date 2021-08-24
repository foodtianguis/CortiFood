import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/PedidoRestModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ViewPedidoRest extends StatefulWidget{
  final int id_Restaurant;

  const ViewPedidoRest({Key key, this.id_Restaurant}) : super(key: key);
  @override
  ViewPedidoRestState createState() => ViewPedidoRestState();

}

class ViewPedidoRestState extends State<ViewPedidoRest>{

  var lista;
  var random;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKeyHist = GlobalKey<RefreshIndicatorState>();

  DefaultTabController Tabs(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          toolbarHeight: 30,
          bottom: TabBar(
            tabs: [
              Text("Pedidos",style: EstiloletrasPestana,),
              Text("Historial de Pedidos",style: EstiloletrasPestana,),
            ],
          ),
        ),
        body: TabBarView(children: [
          Container(child: TabPedido(1),padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
          Container(child: TabPedido(2),padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),)
        ],
        )
      )
    );
  }

  Column TabPedido(int Estatus){
    return Column(
      children: [
        //Expanded(child: Lista(Estatus)),
        Expanded(child: lista != null ? RefreshIndicator(key: Estatus == 1 ? refreshKey : refreshKeyHist, child: Lista(Estatus), onRefresh: refreshList,) :
        //Expanded(child: lista != null ? RefreshIndicator(key: refreshKey , child: Lista(Estatus), onRefresh: refreshList,) :
                                                          Center(child: CircularProgressIndicator()),),
      ],
    );
  }

  ListView _jobsListView(data, Estatus) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _tile(context, data[index], Estatus),
              SizedBox(height: 5,),
            ],
          );
            /*Container(child: Row(
            children: [
              _tile(context, data[index], Estatus),
              SizedBox(width: 5,)
            ],
          ), //padding: EdgeInsets.only(top: 5,),
          //decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),border: Border.all(color: ColorLineas)),
          );*/
        });
  }

  ListView Lista(int Estatus){
    return ListView(
      children: <Widget>[
        FutureBuilder<List<PedidoRestModel>>(
          future: ListViewPedidoRest(widget.id_Restaurant, Estatus),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PedidoRestModel> data = snapshot.data;
              if (data.length == 0)
                return Container(child: Center(child: Text(Estatus ==1 ? 'No Hay Pedidos':Estatus == 2 ? "No hay Historial":"No hay Eliminados", style: Estiloletrasbdj,),),padding: EdgeInsets.symmetric(vertical: 200),);
              else
                return _jobsListView(data, Estatus);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorApp,
                valueColor: new AlwaysStoppedAnimation<Color>(splashBtn),
              ),
            );
          },
        ),
        SizedBox(height: 200,),
      ],
    );
  }

  Container _tile(context, data, Estatus) => Container(
    color: ColorFondo,
    //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 0.2,),),
    child: Column(
      children: [
        Row(children: [
          /*Container(
            height: 97.0, width: 130.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)), //color: Colors.cyanAccent,
                image: DecorationImage(image: Imagen(data.UsuarioFoto))
            ),
          ),
          SizedBox(
            width: 10,
          ),*/
          Column(
            children: [
              Container(
                width: 150,height: 30,
                child: Text("Nombre: ${data.UsuarioNombre.toString()} ${data.UsuarioApellido.toString()}",
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(                              // Direccion
                width: 150,
                height: 50,
                child:
                Text( data.Ubicacion != ""? data.Ubicacion:
                "${data.UsuarioCalle}, ${data.UsuarioCP} ${data.UsuarioColonia} ${data.UsuarioCiudad}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 20,
                child: Text("Estado: ${data.EstatusCodigo.toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Container(width: 150,height: 20,
                child: Text(
                  data.menuNombre.toString(),
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
                ),
              ),
              Container(width: 150,height: 20,
                child: Row(
                  children: [
                    SizedBox(child: Text("Cantidad:"),width: 60,),
                    SizedBox(child: Text("${data.PedidoRestaurantCantidad.toString()}",textAlign: TextAlign.right,), width: 60,),
                  ],
                ),
              ),
              data.PedidoRestaurantComentarios != null?
              Container(width: 150,height: 20,
                child: Text(
                  data.PedidoRestaurantComentarios,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                ),
              ) : Container(width: 150,height: 20,)
              ,
              Container(height: 15,),
            ],
          ),
        ]),

        SizedBox(height: 5,),

        Row(children: [
          SizedBox(width: 10,),
          GestureDetector(
              child: Estatus == 1?
              Link("Mensaje"):
              Link("Detalles"),
              onTap: () {
                vMensajeSys(context, "Click", 3);
                Navigator.pushReplacementNamed(context, '/ViewRestPedido');
              }
          ),
          SizedBox(width: 20,),
          GestureDetector(
              child:  Estatus == 1 && data.PedidoRestaurantEstatus == 1 ? Link("Preparar"):
                      Estatus == 1 && data.PedidoRestaurantEstatus == 2 ? Link("Enviar"):
                      Estatus == 1 && data.PedidoRestaurantEstatus == 4 ? Link("Entregar"):
                      Estatus == 1 && data.PedidoRestaurantEstatus == 5 ? Text("Entregado"):
                      Text(""),
              onTap: () {
                setState(() {
                  if (Estatus == 1){
                    if (data.PedidoRestaurantEstatus == 1) {
                      AccionPreparar(data.PedidoRestaurantid_PedidoDetalle,data.PedidoRestaurantid_Pedido);
                      data.EstatusCodigo = 'PREPARANDO';
                      data.PedidoRestaurantEstatus = 2;
                    } else if (data.PedidoRestaurantEstatus == 2) {
                      AccionEnviar(data.PedidoRestaurantid_PedidoDetalle,data.PedidoRestaurantid_Pedido);
                      data.EstatusCodigo = 'ENVIADO';
                      data.PedidoRestaurantEstatus = 4;
                    } else if (data.PedidoRestaurantEstatus == 4) {
                      AccionEntregado(data.PedidoRestaurantid_PedidoDetalle,data.PedidoRestaurantid_Pedido);
                      data.EstatusCodigo = 'ENTREGADO';
                    }
                  }
                });
                /*
                if (Estatus == 1){
                  if(data.PedidoRestaurantEstatus == 1) {
                    data.EstatusCodigo = 'PREPARANDO';
                    data.PedidoRestaurantEstatus = 2;
                  } else if (data.PedidoRestaurantEstatus == 2){
                    data.EstatusCodigo = 'ENVIADO';
                    data.PedidoRestaurantEstatus = 4;
                  }
                  //Navigator.pushReplacementNamed(context, '/ViewRestPedido');
                }*/
              }
          ),
          SizedBox(width: 20,),
          GestureDetector(
              child: Estatus == 1?
              Link("Cancelar"):
              Link("Detalles"),
              onTap: () {
                setState(() {
                  Estatus == 1?
                    AccionCancelar(data.PedidoRestaurantid_PedidoDetalle, data.PedidoRestaurantid_Pedido):
                    vMensajeSys(context, "Click", 2);
                 // data.EstatusCodigo = 'ENTREGADO';
                });

                //Navigator.pushReplacementNamed(context, '/ViewRestPedido');
                refreshList;
              }
          ),
        ],
        ),
        SizedBox(height: 5,),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Tabs(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    random = Random();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      lista = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }
}

Future<List<PedidoRestModel>> ListViewPedidoRest(int id_Restaurant, int Estatus) async {
  /*
  final repose = Estatus == 1 ? await get("${sURL}Pedido/Restaurante/${id_Restaurant}") :
                                await get("${sURL}Pedido/RestauranteHist/${id_Restaurant}");*/
  final repose = Estatus == 1 ? await get(CadenaConexion("Pedido/Restaurante/${id_Restaurant}")) :
                                await get(CadenaConexion("Pedido/RestauranteHist/${id_Restaurant}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => PedidoRestModel.fromJson(job)).toList();
  } else {
    //throw Exception("Fallo!");
  }
}

Future<void> AccionesCarrito(int id_CarritoDetalle, int Accion) async {
  //final repose = await post("${sURL}Carrito/AccionesCarrito/${id_CarritoDetalle}/${Accion}");
  final repose = await post(CadenaConexion("Carrito/AccionesCarrito/${id_CarritoDetalle}/${Accion}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){

  } else {
    //throw Exception("Fallo!");
  }
}

Future<void> AccionPreparar(int id_PedidoDetalle, int id_Pedido) async {
  //final repose = await post("${sURL}Pedido/Restaurant/AccionPreparar/${id_PedidoDetalle}/${id_Pedido}");
  final repose = await post(CadenaConexion("Pedido/Restaurant/AccionPreparar/${id_PedidoDetalle}/${id_Pedido}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){

  } else {
    //throw Exception("Fallo!");
  }
}

Future<void> AccionEnviar(int id_PedidoDetalle, int id_Pedido) async {
  //final repose = await post("${sURL}Pedido/Restaurant/AccionEnviar/${id_PedidoDetalle}/${id_Pedido}");
  final repose = await post(CadenaConexion("Pedido/Restaurant/AccionEnviar/${id_PedidoDetalle}/${id_Pedido}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){

  } else {
    //throw Exception("Fallo!");
  }
}

Future<void> AccionEntregado(int id_PedidoDetalle, int id_Pedido) async {
  //final repose = await post("${sURL}Pedido/Restaurant/AccionEntregado/${id_PedidoDetalle}/${id_Pedido}");
  final repose = await post(CadenaConexion("Pedido/Restaurant/AccionEntregado/${id_PedidoDetalle}/${id_Pedido}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){

  } else {
    //throw Exception("Fallo!");
  }
}

Future<void> AccionCancelar(int id_PedidoDetalle, int id_Pedido) async {
  final repose = await post(CadenaConexion("Pedido/Restaurant/AccionCancelar/${id_PedidoDetalle}/${id_Pedido}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){

  } else {
    //throw Exception("Fallo!");
  }
}