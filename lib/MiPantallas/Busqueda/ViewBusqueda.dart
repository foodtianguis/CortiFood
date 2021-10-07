import 'dart:convert';
import 'dart:typed_data';

import 'package:dartxero/Api/Api.dart';
import 'package:dartxero/MiFramework/Base/BaseImagen.dart';
import 'package:dartxero/MiFramework/MiAccionLogin.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiFramework/miMenu.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiModel/ImagenModel.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:dartxero/MiPantallas/Busqueda/BusquedaDetalle.dart';
import 'package:dartxero/MiPantallas/Busqueda/MiBusqueda.dart';
import 'package:dartxero/MiPantallas/Carrito/AddCarrito.dart';
import 'package:dartxero/MiPantallas/Pedido/AddPedido.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewBusqueda extends StatefulWidget {
  final BusquedaModel busqueda;

  const ViewBusqueda({Key key, this.busqueda}) : super(key: key);

  @override
  ViewBusquedaState createState() => ViewBusquedaState();
}

class ViewBusquedaState extends State<ViewBusqueda> {
  BusquedaModel NuevaBusqueda;

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return RaisedButton(
            child: _tile(context, data[index]),
            color: ColorFondoApp,
            onPressed: () async {
              NuevaBusqueda = await BusquedaViewDetalle(data[index].id_menu);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          BusquedaDetalle(Busqueda: NuevaBusqueda)));
            },
          );
        });
  }

  Container _tile(context, data) => Container(
      child: Row(children: [
        Container(
          height: 97.0,
          width: 130.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0)), //color: Colors.cyanAccent,
              image: DecorationImage(image: Imagen(data.foto))),
        ),
        Flexible(
          child: SizedBox(
            width: 10,
          ),
        ),
        Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 100,
                child: Text(
                  data.Nombre,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: ColorLabel),
                ),
              ),
            SizedBox(
                width: 5,
            ),
            Container(
              width: 100,
              child: Text(
                data.Descripcion != null ? data.Descripcion : '',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: ColorDescr),
              ),
            ),
          ],
        ),
        Flexible(
          child: SizedBox(
            width: 5,
          ),
        ),
        Container(
          child: SizedBox(
            child: Text(
              '\$ ' + data.Precio.toString() + '0',
              style: TextStyle(fontSize: 10),
            ),
           // width: 40,
          ),
        ),
        Flexible(
          child: SizedBox(
            width: 10,
          ),
        ),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RaisedButton(
                child: Icon(
                  Icons.local_offer,
                  color: ColorBtnTxt,
                ),
                color: ColorBoton,
                splashColor: splashBtn,
                disabledColor: disabledBth,
                padding:
                    EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0, top: 0),
                onPressed: () {
                  print('');
                },
              ),
              RaisedButton(
                child: Icon(
                  Icons.add_shopping_cart_outlined,
                  color: ColorBtnTxt,
                ),
                color: ColorBoton,
                splashColor: splashBtn,
                disabledColor: disabledBth,
                padding:
                    EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0, top: 0),
                onPressed: () {
                  setState(() {});
                  //data.id_restaurant data.id_menu
                },
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          width: 35,
          height: 100,
        ),
      ]));

  ImageProvider ImagenMenu(int id_menu) {
    ImageMenuStr(id_menu);
    Uint8List bytes =
        base64Decode(BASE64_STRING != null ? BASE64_STRING : SinImagen);
    return MemoryImage(bytes);
  }

  Future<String> ImageMenuStr(int id_menu) async {
    //final response = await http.get('${sURL}Menu/ViewPlatillosImagen/${id_menu}',);
    final response = await http.get(
      CadenaConexion('Menu/ViewPlatillosImagen/${id_menu}'),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var Json = json.decode(response.body);
      ImagenModel Imagen = ImagenModel.fromJson(Json[0]);
      setState(() {
        BASE64_STRING = Imagen.foto != Null ? Imagen.foto : SinImagen;
        //BASE64_STRING = Imagen.foto;
      });
    } else
      BASE64_STRING = SinImagen;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      BASE64_STRING = '';
      ImagenMenu(widget.busqueda.id_menu);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Container(child: BaseImagen(sFoto: widget.busqueda.menufoto,nOpcion: 3,),width: double.maxFinite,),
        /*Container(height: 200.0, width: double.maxFinite,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                  image: DecorationImage(image: ImagenMenu(widget.busqueda.id_menu))),
                  ),*/
        Container(
          child: BaseImagen(
            sFoto: BASE64_STRING,
            nOpcion: 3,
          ),
          width: double.maxFinite,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.maxFinite,
          child: Text(
            //widget.busqueda.menuNombre != null ? widget.busqueda.menuNombre: '',
            widget.busqueda.menuNombre.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15, color: ColorLabel),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.maxFinite,
          child: Text(
            widget.busqueda.menuDescripcion != null
                ? widget.busqueda.menuDescripcion
                : '',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: ColorDescr,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          //width: 120,
          child: SizedBox(
            child: Text(
              '\$ ' + widget.busqueda.Precio.toString() + '0',
              style: TextStyle(fontSize: 15, color: ColorLabel),
            ),
            width: double.maxFinite,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: SizedBox(
                width: 30,
              ),
            ),
            RaisedButton(
              child: Text(
                sComprar,
                style: EstiloLetraBtn,
              ),
              color: ColorApp,
              disabledColor: disabledBth,
              splashColor: splashBtn,
              onPressed: () {
                if (RevisaUsuario(context)) {
                  vAddPedido(context, widget.busqueda);
                }
                //PedidoMenu(0,0, 0,"Comentarios");
              },
            ),
          Flexible(
            child: SizedBox(
                    width: 50,
                  ),
          ),
            RaisedButton(
              child: Text(
                sAddCarrito,
                style: EstiloLetraBtn,
              ),
              color: ColorApp,
              disabledColor: disabledBth,
              splashColor: splashBtn,
              onPressed: () {
                if (RevisaUsuario(context)) {
                  vAddCarrito(context, widget.busqueda);
                }
              },
            ),
          ],
        ),
        Expanded(
          child: SizedBox(
            height: 500,
            child: ListView(
              children: <Widget>[
                FutureBuilder<List<MenuModel>>(
                  future: MenuView(widget.busqueda.id_restaurant,
                      widget.busqueda.id_menu, 1), //MenuView(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<MenuModel> data = snapshot.data;
                      if (data.length == 0)
                        return Container(
                          child: Center(
                            child: Text(
                              'Sin mas platillos',
                              style: EstiloLetraLB,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 200),
                        );
                      else
                        return _jobsListView(data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: ColorApp,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(splashBtn),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
