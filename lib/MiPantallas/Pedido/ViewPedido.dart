import 'dart:convert';
import 'dart:math';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/PedidoModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ViewPedido extends StatefulWidget{
  final int id_usuario;

  const ViewPedido({Key key, this.id_usuario}) : super(key: key);
  @override
  ViewPedidoState createState() => ViewPedidoState();

}

class ViewPedidoState extends State<ViewPedido>{

  var lista;
  var random;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKeyHis = GlobalKey<RefreshIndicatorState>();

  DefaultTabController Tabs(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              //title: Text('Tabs, Tabs, Tabs...'),
              primary: false,
              toolbarHeight: 30,
              bottom: TabBar(
                tabs: [
                  Text("Compras",style: EstiloletrasPestana,),
                  Text("Historial de Compras",style: EstiloletrasPestana,),
                ],
              ),
            ),
            body: TabBarView(children: [
              Container(child: TabPedido(1),padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
              Container(child: TabPedido(2),padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),)
            ],
            )));
  }

  Column TabPedido(int Estatus){
    return Column(
      children: [
        SizedBox(height: 15,),
        //Expanded(child: lista != null ? RefreshIndicator(key: refreshKey, child: Lista(Estatus), onRefresh: refreshList,) : Center(child: CircularProgressIndicator()),),
        Expanded(child: lista != null ?
              RefreshIndicator(key: Estatus == 1 ? refreshKey : refreshKeyHis, child: Lista(Estatus), onRefresh: refreshList,) :
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
          return Container(child: _tile(context, data[index], Estatus), padding: EdgeInsets.only(top: 5,),);
        });
  }

  ListView Lista(int Estatus){
    return ListView(
      children: <Widget>[
        FutureBuilder<List<PedidoModel>>(
          future: ListViewPedido(widget.id_usuario, Estatus),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PedidoModel> data = snapshot.data;
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
    //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
    //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 0.2,),borderRadius: BorderRadius.circular(10),),
    child: Column(
      children: [
        Row(children: [
          Container(
            height: 95.0, width: 120.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)), //color: Colors.cyanAccent,
                image: DecorationImage(image: Imagen(data.menumenufoto))
            ),
          ),
          Flexible(
            child: SizedBox(
              width: 10,
            ),
          ),
          Column(
            children: [
              Container(
                width: 120,height: 20,
                child: Text(
                  data.menumenuNombre,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 120,
                height: 50,
                child: Text(
                  data.menumenuDescripcion != null ? data.menumenuDescripcion:'',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: 120,height: 20,
                  child: Text(
                    "Estado: ${data.EstatusCodigo}",
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,),
                  ),
              ),

            ],
          ),
          Flexible(
            child: SizedBox(
              width: 10,
            ),
          ),
          Column(
            children: [
              Container(width: 120,height: 20,
                child: Text(
                  data.menuRestaurantNombre,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(width: 120,height: 20,
                child: Row(
                  children: [
                    SizedBox(child: Text("Cantidad:"),/*width: 60,*/),
                    TabFlexible,
                    SizedBox(child: Text("${data.PedidoDetalleCantidad}",textAlign: TextAlign.right,), /*width: 60,*/),
                  ],
                ),
              ),
              Container(width: 120,height: 20,
                child: Row(
                  children: [
                    SizedBox(child: Text("Precio: "),width: 45,),
                    SizedBox(child: Text("\$ ${data.menumenuPrecio}0",textAlign: TextAlign.right,),width: 75,),
                  ],
                ),
              ),
              Estatus == 1 ? Container(width: 120,height: 20,
                child: Row(
                  children: [
                    SizedBox(child: Text(sComision2Pt),/*width: 45,*/),
                    TabFlexible,
                    SizedBox(child: Text("\$ 3.00",textAlign: TextAlign.right,),/*width: 75,*/),
                  ],
                ),
              ):null,
              Container(
                width: 120,
                child: Row(
                  children: [
                    SizedBox(child: Text('Total:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),)),
                    TabFlexible,
                    SizedBox(child: Text('\$ ' + ((data.menumenuPrecio * data.PedidoDetalleCantidad) + 3).toString() + '0',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),textAlign: TextAlign.right,)),
                  ],
                ),
                //width: 70,
              ),
              Container(height: 15,),
            ],
          ),
        ]),

        SizedBox(height: 5,),

        Row(children: [
          SizedBox(width: 20,),
          GestureDetector(
              child: Estatus == 1?
              Text(sMensaje, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)):
              Text(sDetalles, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
              onTap: () {
                vMensajeSys(context, "Click", 3);
              }
          ),
          SizedBox(width: 20,),
          GestureDetector(
                child: Estatus == 1?
                Text(sCancelar, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)):
                Text(sDetalles, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                onTap: () {
                  vMensajeSys(context, "Click", 2);
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
    refreshKeyHis.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      lista = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }
}

Future<List<PedidoModel>> ListViewPedido(int id_usuario, int Estatus) async {
/*
  final repose = Estatus == 1 ?
                  await get("${sURL}Pedido/Vista/${id_usuario}") :
                  await get("${sURL}Pedido/Historial/${id_usuario}");*/
  final repose = Estatus == 1 ?
                  await get(CadenaConexion("Pedido/Vista/${id_usuario}")) :
                  await get(CadenaConexion("Pedido/Historial/${id_usuario}"));

  if (repose.statusCode == 200 || repose.statusCode == 201){
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => PedidoModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}

Future<void> AccionesCarrito(int id_CarritoDetalle, int Accion) async {
  //final repose = await post("${sURL}Carrito/AccionesCarrito/${id_CarritoDetalle}/${Accion}");
  final repose = await post(CadenaConexion("Carrito/AccionesCarrito/${id_CarritoDetalle}/${Accion}"));
  if (repose.statusCode == 200 || repose.statusCode == 201){

  } else {
    throw Exception("Fallo!");
  }
}