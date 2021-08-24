import 'dart:convert';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/Notificaciones.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiModel/GridInicioModel.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/Api/Api.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiPantallas/Busqueda/ViewBusqueda.dart';
import 'package:dartxero/MiPantallas/Carrito/ViewCarrito.dart';
import 'package:dartxero/MiPantallas/Grids/GridInicio.dart';
import 'package:dartxero/MiPantallas/Pedido/ViewPedido.dart';
import 'package:dartxero/MiUtilidad/MiCategorias.dart';
import 'package:dartxero/MiUtilidad/MiSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BandejaUsuario extends StatefulWidget {
  final int nIndex;
  final int nOpcion; /*0 Menu inicio,  1 Menu Busqueda*/
  final BusquedaModel busqueda; /* si nOpcion = 0 este parametro es NULL*/
  final BuildContext Bcontext;

  const BandejaUsuario(
      {Key key, this.nIndex, this.nOpcion, this.busqueda, this.Bcontext})
      : super(key: key);
  @override
  _BandejaUsuario createState() => _BandejaUsuario();
}

class _BandejaUsuario extends State<BandejaUsuario> {
  MyPreferences _myPreferences = MyPreferences();
  int _selectedIndex = 0;
  String sMensaje = '';
  String _sTitulo = '';
  int _nOpcion;
  Drawer _dw;

  Future<void> _Login() async {
    try {
      _myPreferences.init().then((value) {
        setState(() {
          _myPreferences = value;
        });
      });

      if (_myPreferences.automatic == true) {
        final response = await http.get(
          //"${sURL}Login/In/${_myPreferences.user.replaceAll(' ', '')}/${_myPreferences.password}",
          CadenaConexion(
              "Login/In/${_myPreferences.user.replaceAll(' ', '')}/${_myPreferences.password}"),
          //"${sURL}Login/In/${sUser}/${sPass}",
        );
        var jSon = json.decode(response.body);
        dUsuarioGLB = jSon;
        user = UserModel.fromJson(jSon[0]);
        if (response.statusCode == 201 || response.statusCode == 200) {
          if (user.TipoUsuario == 1)
            Navigator.pushReplacementNamed(widget.Bcontext, '/BandejaUs');
          else if (user.TipoUsuario == 2)
            //Restaurant = await RestaurantView(user.id);
            Navigator.pushReplacementNamed(widget.Bcontext, '/BandejaRest');
        } else {
          setState(() {
            sMensaje = sMensajeErrorLoguin;
            bLogueado = false;
            user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
          });
        }
      } else {
        bLogueado = false;
        user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
      }
    } on Exception catch (ex) {
      print('Error: ${ex.toString()}');
      bLogueado = false;
      user = UserModel.fromJson(json.decode(sJsonVacio.trim())[0]);
    }
    //return db;
  }

  Container Body(int index) {
    switch (index) {
      case 0:
        return Opciones(_nOpcion);
        break;
      case 1:
        return Container(
          child: ViewCarrito(
            id_usuario: user.id,
          ),
          color: ColorFondo,
        );
        break;
      case 2:
        return Container(
          child: ViewPedido(
            id_usuario: user.id,
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
        );
        break;
      case 3:
        return Container(child: Center(child: Text('Mensajes')));
        break;
    }
  }

  Widget Opciones(int nOpcion) {
    switch (nOpcion != null ? nOpcion : 0) {
      case 0:
        return Container(
          child: Column(
            children: [
              /*Container(
            height: 80,
            child: BarraCateforias(),
            color: Colors.indigoAccent,
          ),*/
              SizedBox(
                height: 5,
              ),
              /*Container(
            height: 150,
            child: Cartelon(),
            //color: Colors.purpleAccent,
          ),*/
              //Container(height: 300,),
              //Expanded(child: GridHome())
              //Container(height: 5,),
              Expanded(child: GridInicio())
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
        );
        break;
      case 1:
        return Container(
          child: ViewBusqueda(
            busqueda: widget.busqueda,
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
        );
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _nOpcion = 0;
      _selectedIndex = index;
      _sTitulo = sCambioTitulo(_selectedIndex);
    });
  }

  String sCambioTitulo(int nindex) {
    switch (nindex) {
      case 0:
        return sNomApp;
      case 1:
        return "Carrito";
      case 2:
        return "Compras";
      case 3:
        return "Mensajes";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _sTitulo,
          style: EstiloletrasTitulo,
        ),
        actions: <Widget>[
          iBusqueda(context),
          /*IconButton(icon: iSrch,color: ColorBtnTxt,
              onPressed:() {
                showSearch(context: context,delegate: Search());
              }),*/
        ],
      ),
      //drawer: _dw,
      drawer: vDrawerLogin(),
      body: Body(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: _selectedIndex == 0 && _nOpcion == 1
          ? Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                FloatingActionButton(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: ColorBtnTxt,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          : null,
      bottomNavigationBar: (user?.id ?? 0) > 0
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Inicio'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  title: Text('Carrito'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer),
                  title: Text('Compras'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail_outline),
                  title: Text('Mensajes'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: ColorSelect,
              unselectedItemColor: ColorAppMat,
              onTap: _onItemTapped,
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _nOpcion = widget.nOpcion;
      _selectedIndex = widget.nIndex;
      _sTitulo = sCambioTitulo(_selectedIndex);
      //_dw = DrawerUser().dw(context);
    });
    if ((bLogueado ?? false) == false) {
      //_Login();
      _myPreferences.init().then((value) {
        setState(() {
          _myPreferences = value;
          _Login();
          //login.createState();
        });
      });
    }

    if (widget.nIndex == 0) {
      setState(() {
        TokenNotificaciones token = TokenNotificaciones();
        token.initToken(user.id);

        token.mensaje.listen((event) {
          if (event == 'UsuarioResume') {
            Navigator.pushReplacementNamed(context, '/BandejaUserPedido');
          } else if (event == 'UsuarioMessage') {
            if (_selectedIndex != 2) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    //title: Text('Notificacion'),
                    title: Text(NotificacionLocal.Title),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          //Text('Nuevo Pedido'),
                          Text(NotificacionLocal.Body),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('ir a Compras'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/BandejaUserPedido');
                        },
                      ),
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          //Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              //Navigator.pushReplacementNamed(context, '/BandejaUserPedido');
            }
          }
        });
      });
    }
  }
}
