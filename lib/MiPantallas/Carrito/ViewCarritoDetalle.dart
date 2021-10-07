import 'dart:convert';

import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajeUsuario.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/CarritoModel.dart';
import 'package:dartxero/MiPantallas/Carrito/ViewCarrito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ViewCarritoDetalle extends StatefulWidget{
  final int id_usuario;

  const ViewCarritoDetalle({Key key, this.id_usuario}) : super(key: key);

  @override
  ViewCarritoDetalleState createState() => ViewCarritoDetalleState();
}

class ViewCarritoDetalleState extends State<ViewCarritoDetalle>{

  ListView Lista(int Estatus) {
    return ListView(
      children: <Widget>[
        FutureBuilder<List<CarritoModel>>(
          future: ListViewCarrito(widget.id_usuario, Estatus),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CarritoModel> data = snapshot.data;
              if (data.length == 0)
                return Container(
                  child: Center(
                    child: Text(
                      Estatus == 1
                          ? 'Carrito Vacio'
                          : Estatus == 2
                          ? "No hay Guardados"
                          : "No hay Eliminados",
                      style: Estiloletrasbdj,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 200),
                );
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
        SizedBox(
          height: 200,
        ),
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
          return Container(
            child: _tile(context, data[index], Estatus),
            padding: EdgeInsets.only(bottom: 5.0),
          );
        });
  }

  Container _tile(context, data, Estatus) => Container(
    color: ColorFondo,
    padding: EdgeInsets.only(bottom: 5),
    //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 0.2,),borderRadius: BorderRadius.circular(10),),
    child: Column(
      children: [
        Row(children: [
          Container(
            height: 97.0,
            width: 130.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft:
                    Radius.circular(10.0)), //color: Colors.cyanAccent,
                image: DecorationImage(image: Imagen(data.menufoto))),
          ),
          Flexible(
            child: SizedBox(
              width: 10,
            ),
          ),
          Column(
            children: [
              Container(
                width: 120,
                height: 20,
                child: Text(
                  data.menuNombre,
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
                height: 70,
                child: Text(
                  data.menuDescripcion ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
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
              Container(
                width: 120,
                height: 20,
                child: Text(
                  data.RestaurantNombre,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 20,
                child: Row(
                  children: [
                    SizedBox(
                      child: Text("Cantidad:"),
                      width: 60,
                    ),
                    SizedBox(
                      child: Text(
                        "${data.CarritoDetalleCantidad}",
                        textAlign: TextAlign.right,
                      ),
                      width: 60,
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 20,
                child: Row(
                  children: [
                    SizedBox(
                      child: Text("Precio: "),
                      width: 45,
                    ),
                    SizedBox(
                      child: Text(
                        "\$ ${data.menuPrecio}0",
                        textAlign: TextAlign.right,
                      ),
                      width: 75,
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                child: Row(
                  children: [
                    SizedBox(
                      child: Text(
                        'Total:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      width: 45,
                    ),
                    SizedBox(
                      child: Text(
                        '\$ ' +
                            (data.menuPrecio * data.CarritoDetalleCantidad)
                                .toString() +
                            '0',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      width: 75,
                    ),
                  ],
                ),
                //width: 70,
              ),
              Container(
                height: 15,
              ),
            ],
          ),
        ]),
        //Divider(color: Colors.black12,height: 10, thickness: 2,),
        SeparadorFit,
        Row(
          children: [
            GestureDetector(
                child: Link(sComprar),
                //Text("Comprar", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                onTap: () {
                  //vMensajeSys(context, "Click", 4);
                  setState(() {
                    //PedidoCarritoDetalle(data.Carritoid_Usuario, data.CarritoDetalleid_CarritoDetalle);
                    RealizaCompra(context, data);
                  });
                }),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
                child: Estatus == 1
                    ? Link("Guardar")
                    : Link("Agregar al Carrito"),
                //Text("Guardar", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)):
                //Text("Agregar al Carrito", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                onTap: () {
                  //vMensajeSys(context, "Click", 3);
                  setState(() {
                    if (Estatus == 1)
                      AccionesCarrito(
                          data.CarritoDetalleid_CarritoDetalle, 2);
                    else if (Estatus == 2)
                      AccionesCarrito(
                          data.CarritoDetalleid_CarritoDetalle, 1);
                  });
                }),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
                child: Link("Eliminar"),
                //Text("Eliminar", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                onTap: () {
                  AccionesCarrito(data.CarritoDetalleid_CarritoDetalle, 3);
                }),
          ],
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


  Future<List<CarritoModel>> ListViewCarrito(int id_usuario, int Estatus) async {
    //final repose = await get("${sURL}Carrito/VerCarrito/${id_usuario}/${Estatus}");
    final repose =
    await get(CadenaConexion("Carrito/VerCarrito/${id_usuario}/${Estatus}"));
    if (repose.statusCode == 200 || repose.statusCode == 201) {
      List jsonResponse = json.decode(repose.body);
      return jsonResponse.map((job) => CarritoModel.fromJson(job)).toList();
    } else {
      throw Exception("Fallo!");
    }
  }
}