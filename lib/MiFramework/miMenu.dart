import 'dart:convert';
import 'dart:math';
import 'package:dartxero/Listas/ListadosUso.dart';
import 'package:dartxero/MiFramework/Base/BaseSubCategoria.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:dartxero/MiPantallas/Menu/MenuEdit.dart';
import 'package:dartxero/MiUtilidad/MiPhoto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MiAcciones.dart';
import 'MiControllerGlobales.dart';
import 'MiVariablesGlobales.dart';
import 'package:http/http.dart' as http;

Future<List<MenuModel>> MenuView(int id_restaurant, int IDExcluPlatillo, int EsBusqueda) async {
  if (RefListadoMenu || EsBusqueda ==1) {
    //final repose = await http.get("${sURL}Menu/ViewPlatillos/${id_restaurant}/${IDExcluPlatillo}");
    final repose = await http.get(CadenaConexion("Menu/ViewPlatillos/${id_restaurant}/${IDExcluPlatillo}"));
    if (repose.statusCode == 200 || repose.statusCode == 201) {
      List jsonResponse = json.decode(repose.body);
      ListadoMenu = jsonResponse;
      RefListadoMenu = false;
      return jsonResponse.map((job) => MenuModel.fromJson(job)).toList();
      //return JsonFinal;
    } else {
      throw Exception("Fallo!");
    }
  }else
    return ListadoMenu.map((job) => MenuModel.fromJson(job)).toList();
}

class miMenu extends StatefulWidget {
  final int id_Restaurant;
  final int IDExcluPlatillo;
  const miMenu({Key key, this.id_Restaurant, this.IDExcluPlatillo}) : super(key: key);

  @override
  _miMenuState createState() => _miMenuState();
}

class _miMenuState extends State<miMenu> {

  var lista;
  var random;
  List<MenuModel> OldData;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
            return Container(child: Column(
              children: [
                _tile(context, data[index]),
                SizedBox(height: 5,),
              ],
            ));
        });
  }

  Container _tile(context, data) => Container(
    color: ColorFondo,
    //padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
      //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 1,),borderRadius: BorderRadius.circular(10),),
      child: Row(children: [
        Container(
          child: //PhotoView(imageProvider: Imagen(data.foto),),
          data.foto != null ? Image(height: 97.0, width: 130.0, image:Imagen(data.foto),) : Container(child: Center(child: Text('No Hay Foto',)), height: 97.0, width: 130.0,),
          //decoration: esMarcoFotos,
        ),
        Flexible(child: SizedBox(width: 0,),flex: 3,fit: FlexFit.tight,),
        Column(
          children: [
            Container(
              width: 120,
              child: Text(
                data.Nombre != null? data.Nombre : '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 120,
              child: Text(
                data.Descripcion != null? data.Descripcion : '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        //SizedBox(width: 5,),
        Flexible(child: SizedBox(width: 0,),flex: 3,fit: FlexFit.tight,),
        Container(
          child: Row(
            children: [
              SizedBox(
                  child: Text('\$ ' + data.Precio.toString() + '0',),
                  //width: 50,
                ),
              SizedBox(width: 5,),
              Container(
                alignment: Alignment.centerLeft,
                width: 35,
                height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RaisedButton(
                      child: Icon(Icons.edit,
                        color: ColorBtnTxt,
                      ),
                      color: ColorBoton,
                      padding: EdgeInsets.only(left: 0.0, right: 0.0,bottom: 0,top: 0),

                      splashColor: splashBtn,
                      disabledColor: disabledBth,
                      onPressed: () {
                        //PlatilloDelete(data.id_restaurant,data.id_menu);
                        PlatilloEditView(context, data);
                      },
                    ),
                    RaisedButton(
                      child: Icon(Icons.delete,
                        color: ColorBtnTxt,
                      ),
                      color: ColorBoton,
                      padding: EdgeInsets.only(left: 0.0, right: 0.0,bottom: 0,top: 0),
                      splashColor: splashBtn,
                      disabledColor: disabledBth,
                      onPressed: () {
                        setState(() {
                          print(data.id_menu);
                          PlatilloDelete(data.id_menu, data.id_restaurant, context);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
  );

  ListView listaMenu(){
    return ListView(
      children: <Widget>[
        FutureBuilder<List<MenuModel>>(
          future: MenuView(widget.id_Restaurant, widget.IDExcluPlatillo, 0), //MenuView(),

          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MenuModel> data = snapshot.data;
              if (data.length == 0)
                return Container(child:Center(child: Text(sMenuVacio,style: Estiloletrasbdj,),),padding: EdgeInsets.symmetric(vertical: 250),
                );
              else
                return _jobsListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              heightFactor: 200,
              child: CircularProgressIndicator(
                backgroundColor: ColorApp,
                valueColor: new AlwaysStoppedAnimation<Color>(splashBtn),
              ),
            );
          },
        ),
        SizedBox(height: 150,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return lista != null ? RefreshIndicator(key: refreshKey, child: listaMenu(), onRefresh:refreshList,) :Center(child: CircularProgressIndicator());
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      random = Random();

      refreshList();
      RefListadoMenu = ListadoMenu == null;
    }

  Future<Null> refreshListAux() async {
    RefListadoMenu = true;
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      lista = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }

  Future<Null> refreshList() async {
    RefListadoMenu = true;
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      lista = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }  
}

void MenuAddShow(BuildContext context) {
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
                  child: MenuAdd(),
                ),
              ],
            )
        );
      });
}

class MenuAdd extends StatefulWidget {
  @override
  _MenuAddState createState() => _MenuAddState();
}

class _MenuAddState extends State<MenuAdd> {
  final _formKey = GlobalKey<FormState>();

  bool bValidaAceptar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      txtPlaNombre.text = "";
      txtPlaDescripcion.text = "";
      txtPlaTipoCategoria.text = "";
      txtPlaPrecio.text = "";
      txtPlaExtras.text = "";
      MaskPrecioPlo.text = "0.00";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PhotoPreviewScreen(sTraeImagen: '',),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              decoration: InpDecoTxt("Nombre"),
              style: EstiloLetraLB,
              autofocus: true,
              controller: txtPlaNombre,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              maxLines: 2,
              decoration: InpDecoTxt("Descripción",),
              style: EstiloLetraLB,
              controller: txtPlaDescripcion,
            ),
          ),
          Container(child: BaseSubCategoria(VerTodos: 0,Categoria: Restaurant.TipoCategoria,Seleccionada: null,menu: null,),),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              decoration: InpDecoTxt("Precio"),
              style: EstiloLetraLB,
              controller: MaskPrecioPlo,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              decoration: InpDecoTxt("Extras",),
              style: EstiloLetraLB,
              controller: txtPlaExtras,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: RaisedButton(
              child: Text(
                "Aceptar",
                style: EstiloLetraBtn,
              ),
              color: ColorBoton,
              splashColor: splashBtn,
              disabledColor: disabledBth,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    if (!bValidaAceptar){
                      bValidaAceptar = true;
                      CargarPlatillo(context);
                      bValidaAceptar = false;
                    }
                  });
                  //Navigator.pushReplacementNamed(context, '/BandejaRest');
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}

Future<void> CargarPlatillo(BuildContext context) async {
  Menu = await PlatilloAdd();
  RefListadoMenu = true;
  Navigator.pop(context);
  Navigator.pushReplacementNamed(context, '/BandejaRest');
}

Future<MenuModel> PlatilloAdd() async {
  String img64 = '';
  String img64M = '';
  if (imageFile != null)
    img64 = base64Encode(imageFile.readAsBytesSync());
  if (imageFileM != null)
    img64M = base64Encode(imageFileM.readAsBytesSync());
  //final response = await http.post('${sURL}Menu/AddPlatillo', body: {
  final response = await http.post(CadenaConexion('Menu/AddPlatillo'), body: {
    'id_restaurant': Restaurant.id_Restaurant.toString(),
    'Nombre': txtPlaNombre.text,
    'Descripcion': txtPlaDescripcion.text,
    'Activo': 'ACTIVO',
    'TipoCategoria': txtPlaSubCategoria.text,
    'Precio': MaskPrecioPlo.text.replaceAll('\$', ''),
    'Extras': txtPlaExtras.text,
    'foto': img64,
  });
  if (response.statusCode == 201 || response.statusCode == 200) {
    var jSon = json.decode(response.body);
    print(img64);
    return MenuModel.fromJson(jSon[0]);
  } else {
    return null;
  }
}

Future<void> PlatilloDelete(int id_menu,int id_restaurant, BuildContext context) async {
  //final response = await http.get('${sURL}Menu/DeletePlatillo/${id_menu}/${id_restaurant}',);
  final response = await http.get(CadenaConexion('Menu/DeletePlatillo/${id_menu}/${id_restaurant}'),);
  if (response.statusCode == 201 || response.statusCode == 200) {
   // BandejaRestaurant()
    RefListadoMenu = true;
    Navigator.pushReplacementNamed(context, '/BandejaRest');
  }
}

void PlatilloEditView(BuildContext context, MenuModel Data) {
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
                  child: MenuEdit(Data: Data),
                ),
              ],
            )
        );
      });
}
