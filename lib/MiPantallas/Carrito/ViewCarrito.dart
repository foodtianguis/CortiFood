import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dartxero/Acciones/Pedidos/AccionPedido.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiComponenteGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajeUsuario.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/CarritoEncaModel.dart';
import 'package:dartxero/MiModel/CarritoModel.dart';
import 'package:dartxero/MiModel/EncaCarritoModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

class ViewCarrito extends StatefulWidget {
  final int id_usuario;

  const ViewCarrito({Key key, this.id_usuario}) : super(key: key);
  @override
  ViewCarritoState createState() => ViewCarritoState();
}

class ViewCarritoState extends State<ViewCarrito> {
  CarritoEncaModel Encabezado = CarritoEncaModel();
  var lista;
  var random;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKeyHist = GlobalKey<RefreshIndicatorState>();

  String _CP;
  String _Colonia;

  Future<void> AsignaEnca(int id_usuario) async {
    final aux = await EncabezadoCarrito(id_usuario);
    setState(() {
      Encabezado = aux;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      AsignaEnca(widget.id_usuario);

      _CP = user.cp;
      _Colonia = user.Colonia;
    });

    random = Random();
    refreshList();
  }

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

  ListView EncaLista(int Estatus, String CP, String Colonia) {
    return ListView(
      children: <Widget>[
        FutureBuilder<List<EncaCarritoModel>>(
          future: ListViewEncaCarrito(widget.id_usuario, Estatus, CP, Colonia),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EncaCarritoModel> data = snapshot.data;
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
                return _EncaListView(data, Estatus);
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

  ListView _EncaListView(data, Estatus) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            child: _Encabezado(context, data[index], Estatus),
            padding: EdgeInsets.only(bottom: 5.0),
          );
        });
  }

  Container _Encabezado(context, data, Estatus) => Container(
        color: ColorFondo,
        padding: EdgeInsets.only(bottom: 5),
        //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 0.2,),borderRadius: BorderRadius.circular(10),),
        child: Column(
          children: [
            Row(children: [
              Container(
                height: 97.0,
                width: 130.0,
                child: Icon(Icons.shopping_cart_outlined,color: ColorAppMat,size: 50,),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(10.0)), //color: Colors.cyanAccent,
                    //image: DecorationImage(image: Imagen(data.menufoto))
                ),
              ),
              Flexible(
                  child: SizedBox(
                width: 5,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        //height: 20,
                        child: Text(
                          data.RestaurantNombre,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
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
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text("Total Platillos:"),
                          //width: 60,
                        ),
                        TabFlexibleS,
                        SizedBox(
                          child: Text(
                            "${data.TotalPlatillos.toString()}",
                            textAlign: TextAlign.right,
                          ),
                          //width: 60,
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
                          child: Text("Envio :"),
                          //width: 60,
                        ),
                        TabFlexibleS,
                        SizedBox(
                          child: Text(
                            "${data.Comision.toString()}",
                            textAlign: TextAlign.right,
                          ),
                          //width: 60,
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
                          child: Text("SubTotal :"),
                          //width: 65,
                        ),
                        TabFlexibleS,
                        SizedBox(
                          child: Text(
                            "\$ ${data.Total.toString()}0",
                            textAlign: TextAlign.right,
                          ),
                         /// width: 75,
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
                                (data.Total + data.Comision)
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

  Column TabCarrito(BuildContext context, int Estatus) {
    return Column(
      children: [
        //Flexible(child:Lista(Estatus),),
        Flexible(
          child: lista != null
              ? RefreshIndicator(
                  key: Estatus == 1 ? refreshKey : refreshKeyHist,
                  //child: Lista(Estatus),
                  child: EncaLista(Estatus, _CP, _Colonia),
                  onRefresh: refreshList,
                )
              : Center(child: CircularProgressIndicator()),
        ),
        SizedBox(
          height: 15,
        ),
        Column(
          children: [
            Row(
              children: [
                Text(sDireccion2Pt),
                Flexible(
                  child: SizedBox(
                    width: 0,
                  ),
                  flex: 3,
                  fit: FlexFit.tight,
                ),
                Container(
                    child: Text(
                  "${Encabezado.Direccion != null ? Encabezado.Direccion.substring(0, 30) : ""}",
                  textAlign: TextAlign.left,
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(child: Text(sComision2Pt)),
                Flexible(
                  child: SizedBox(
                    width: 0,
                  ),
                  flex: 3,
                  fit: FlexFit.tight,
                ),
                (Encabezado?.ComisionTotal ?? 0) > 0
                    ? Container(
                        child: Text(
                        "x${Encabezado.CantidadRest}",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ))
                    : SizedBox(
                        width: 0,
                      ),
                (Encabezado?.ComisionTotal ?? 0) > 0
                    ? SizedBox(
                        width: 10,
                      )
                    : SizedBox(
                        width: 0,
                      ),
                Container(
                    child: Text(
                        (Encabezado?.ComisionTotal ?? 0) > 0
                            ? "\$ ${Encabezado.ComisionTotal * Encabezado?.CantidadRest ?? 1}0"
                            : "\$ 0.00",
                        textAlign: TextAlign.left)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  child: Text(sTotal2Pt),
                  width: 50,
                ),
                Flexible(
                  child: SizedBox(
                    width: 0,
                  ),
                  flex: 3,
                  fit: FlexFit.tight,
                ),
                Container(
                    child: Text(
                        "${(Encabezado?.PrecioCarrito ?? 0) > 0 ? "\$ ${Encabezado.PrecioCarrito + (Encabezado?.ComisionTotal ?? 0 * Encabezado?.CantidadRest ?? 1)}0" : "\$ 0.00"}",
                        textAlign: TextAlign.left)),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Estatus == 1
            ? TabBotonesCarrito(context, widget.id_usuario, Estatus)
            : Text(""),
        //Expanded(child: Lista(Estatus)),
      ],
    );
  }

  Container TabBotonesCarrito(
      BuildContext context, int id_usuario, int Estatus) {
    return Container(
      child: RaisedButton(
        child: Text(
          "Comprar Carrito",
          style: EstiloLetraBtn,
        ),
        color: ColorApp,
        disabledColor: disabledBth,
        splashColor: splashBtn,
        onPressed: () {
          if (Encabezado.id_Carrito != null)
            DialogSys(
                context,
                Container(
                  height: 150,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${Encabezado.Direccion}",
                        maxLines: 5,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              child: Link(sConfirma),
                              onTap: () {
                                PedidoCarrito(
                                    id_usuario, Encabezado.id_Carrito);
                                Navigator.pushReplacementNamed(
                                    context, '/BandejaUserCarrito');
                                //Navigator.pop(bContext);
                              }),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              child: Link(sCancelar),
                              onTap: () {
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ));
        },
      ),
      color: ColorFondoApp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tabs(context);

    /*Column(
      children: [
        Text("Titulo"),
        SizedBox(height: 15,),
        Expanded(child: Lista()),
        //SizedBox(height: 15,),
        //Text("Acciones"),
      ],
    );*/
  }

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
                  Text(
                    "Carrito",
                    style: EstiloletrasPestana,
                  ),
                  Text(
                    "Guardados",
                    style: EstiloletrasPestana,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  child: TabCarrito(context, 1),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                ),
                Container(
                  child: TabCarrito(context, 2),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                )
              ],
            )));
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    refreshKeyHist.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      lista = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }
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

Future<List<EncaCarritoModel>> ListViewEncaCarrito(int id_usuario, int Estatus, String CP, String Colonia) async {
  final repose = await get(CadenaConexion("/Carrito/VerCarritoEnca/${id_usuario}/${Estatus}/${CP}/${Colonia}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => EncaCarritoModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}

Future<void> AccionesCarrito(int id_CarritoDetalle, int Accion) async {
  //final repose = await post("${sURL}Carrito/AccionesCarrito/${id_CarritoDetalle}/${Accion}");
  final repose = await post(
      CadenaConexion("Carrito/AccionesCarrito/${id_CarritoDetalle}/${Accion}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
  } else {
    throw Exception("Fallo!");
  }
}

Future<CarritoEncaModel> EncabezadoCarrito(int id_usuario) async {
  //final repose = await get("${sURL}Carrito/EncabezadoCarrito/${id_usuario}");
  final repose =
      await get(CadenaConexion("Carrito/EncabezadoCarrito/${id_usuario}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    return CarritoEncaModel.fromJson(json.decode(repose.body)[0]);
  } else {
    throw Exception("Fallo!");
  }
}
