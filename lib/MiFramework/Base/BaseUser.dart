import 'package:dartxero/Api/Api.dart';
import 'package:dartxero/MiFramework/Base/BaseImagen.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miMenu.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:dartxero/MiPantallas/Restaurante/BusquedaPlatillos.dart';
import 'package:dartxero/MiUtilidad/MiCategorias.dart';
import 'package:dartxero/MiUtilidad/MiSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseUser extends StatefulWidget{
  final String sTitulo;
  final int nOpcion;/* 0 Menu de inicio, 1 Menu de busqueda*/
  final BusquedaModel busqueda;

  const BaseUser({Key key, this.sTitulo, this.nOpcion, this.busqueda}) : super(key: key);
  @override
  BaseUserState createState() => BaseUserState();
}

class BaseUserState extends State<BaseUser>{
  int _selectedIndex = 0;
  String sMensaje = '';


  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Container Body(){
    switch (_selectedIndex){
      case 0: return Opciones(widget.nOpcion);
      break;
      case 1: return Container(child: Center(child: Text('Pedidos')));
      break;
      case 2: return Container(child: Center(child: Text('Mensajes')));
      break;
    }
  }

  Widget Opciones(int nOpcion){
    switch(nOpcion){
      case 0: return Container(child: ListView(children: [
        Container(height: 80,child: BarraCateforias(),color: Colors.indigoAccent,),
        Container(height: 150,child: Cartelon(),color: Colors.purpleAccent,),
        Container(height: 300,)]
      ),padding: EdgeInsets.symmetric(horizontal: 5));
      break;
      case 1: return Container(child:
                                ListView(children: [
                                  Container(
                                    child: BaseImagen(sFoto: widget.busqueda.menufoto,nOpcion: 0,)
                                    //widget.busqueda.menufoto != null ? Image(height: 200.0, width: 130.0, image:Imagen(widget.busqueda.menufoto), ) : Container(child: Center(child: Text('No Hay Foto',)), height: 200.0, width: 130.0,),
                                    //decoration: esMarcoFotos,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 120,
                                    child: Text(
                                      widget.busqueda.menuNombre,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: ColorApp
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 120,
                                    child: Text(
                                      widget.busqueda.menuDescripcion,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 120,
                                    child: SizedBox(
                                      child: Text('\$ ' + widget.busqueda.Precio.toString() + '0', style: TextStyle(fontSize: 15,color: ColorApp),),
                                      width: 70,
                                    ),
                                  ),
                                  //Expanded(child: SizedBox( height: 500, child: miMenu(id_Restaurant: widget.busqueda.id_restaurant,IDExcluPlatillo: widget.busqueda.id_menu,)),)
                                  Expanded(child: SizedBox(
                                    height: 500,
                                    child: ListView(
                                      children: <Widget>[
                                        FutureBuilder<List<MenuModel>>(
                                          future: MenuView(widget.busqueda.id_restaurant, widget.busqueda.id_menu, 0), //MenuView(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<MenuModel> data = snapshot.data;
                                              if (data.length == 0)
                                                return Container(child: Center(child: Text('Menú Vacio', style: EstiloLetraLB,),),padding: EdgeInsets.symmetric(vertical: 200),);
                                              else
                                                return _jobsListView(data);
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
                                    ),
                                  ),),
                                ],),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            );
      break;
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return RaisedButton(child: _tile(context, data[index]), color: ColorFondoApp, onPressed: () {

          },);
        });
  }

  Container _tile(context, data) => Container(
      //padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
      //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 1,),borderRadius: BorderRadius.circular(10),),
      child: Row(children: [
        Container(
          child: //PhotoView(imageProvider: Imagen(data.foto),),
          data.foto != null ? Image(height: 97.0, width: 130.0, image:Imagen(data.foto), ) : Container(child: Center(child: Text('No Hay Foto',)), height: 97.0, width: 130.0,),
          //decoration: esMarcoFotos,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Container(
              width: 120,
              child: Text(
                data.Nombre,
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
                data.Descripcion,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          child: SizedBox(
            child: Text('\$ ' + data.Precio.toString() + '0',),
            width: 50,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
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

                  });
                  //data.id_restaurant data.id_menu
                },
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          width: 37,
          height: 100,
          color: Colors.deepPurpleAccent,
        ),
      ])
  );

  AppBar Titulo(String sTitulo){
    return AppBar(
      title: Text(sTitulo),
      actions: <Widget>[
        IconButton(
            icon: iSrch,
            onPressed:() {
              showSearch(context: context,delegate: Search());
            }),
        widget.nOpcion != 0 ? IconButton(
            icon: iBack,
            onPressed:() {
              Navigator.pop(context);
            }) : null,
      ],
    );
  }

  BottomNavigationBar Navegador(){
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Inicio'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          title: Text('Ofertas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail_outline),
          title: Text('Mensajes'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: ColorApp,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Titulo(widget.sTitulo),
      drawer: vDrawerLogin(),
      body: Body(),
      bottomNavigationBar: Navegador(),
    );
  }

}