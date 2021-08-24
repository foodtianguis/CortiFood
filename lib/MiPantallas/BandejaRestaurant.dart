import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:dartxero/Listas/ListadosUso.dart';
import 'package:dartxero/MiFramework/Notificaciones.dart';
import 'package:dartxero/MiModel/ColoniasModel.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiFramework/miMenu.dart';
import 'package:dartxero/MiFramework/miRestaurant.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:dartxero/MiPantallas/Restaurante/ColoniasRestaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Pedido/ViewPedidoRest.dart';
import 'Restaurante/DrawerRestaurant.dart';
import 'Restaurante/SearchColonia.dart';

class BandejaRestaurant extends StatefulWidget {
  final int nIndex;

  const BandejaRestaurant({Key key, this.nIndex}) : super(key: key);
  @override
  _BandejaRestaurant createState() => _BandejaRestaurant();
}

class _BandejaRestaurant extends State<BandejaRestaurant> {
  MyPreferences _myPreferences = MyPreferences();
  int _selectedIndex = 0;
  String sMensaje = '';
  String _sTitulo;
  bool _bigger = false;
  Timer _timer;

  Future<List<MenuModel>> Menu;

  void CargarRest() async {
    bLogueado = true;
    Restaurant = await RestaurantView(user.id);
    //IniRestaurant = await TieneColonias(Restaurant.id_Restaurant);
    //Menu = MenuView(Restaurant.id_Restaurant);
    IniRestaurant = true;
    Navigator.pushReplacementNamed(context, '/BandejaRest');
  }

  @override
  Future<void> initState() {
    super.initState();
    setState(() {
      ListadoMenu = null;
      _selectedIndex = widget?.nIndex ?? 0;
      _sTitulo = sCambioTitulo(_selectedIndex);
    });

    startTimer();
    if ((bLogueado ?? false) == false) {
      setState(() {
        CargarRest();
      });
    }

    if (widget.nIndex == 0) {
      setState(() {
        TokenNotificaciones token = TokenNotificaciones();
        token.initToken(user.id);

        token.mensaje.listen((event) {
          if (event == 'RestaurantResume') {
            Navigator.pushReplacementNamed(context, '/BandejaRestPedido');
          } else if (event == 'RestaurantMessage') {
            if (_selectedIndex != 1) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Notificacion'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Nuevo Pedido'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('ir a Pedidos'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/BandejaRestPedido');
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
            } else {}
          } else if (event == 'NotifiUser') {}
        });
      });
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> tabs = <Widget>[
    //Expanded(child: Restaurant != null ? Container(child: miMenu(),padding: EdgeInsets.symmetric(horizontal: 5),): Container(),),
    Restaurant != null
        ? Container(
            child: miMenu(
              id_Restaurant: Restaurant.id_Restaurant,
              IDExcluPlatillo: 0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5),
          )
        : Container(
            child: Center(
              child: Text(
                "${sMenuVacio}",
              ),
            ),
          ),
    //Expanded(child: Restaurant != null ? Container(child: Center(child: Text('Pedidos'))): Container(),),
    Restaurant != null
        ? Container(
            child: Center(
                child: ViewPedidoRest(
              id_Restaurant: Restaurant.id_Restaurant,
            )),
            padding: EdgeInsets.symmetric(horizontal: 5),
          )
        : Container(
            child: Center(
              child: Text(
                'No Hay pedidos',
                style: Estiloletrasbdj,
              ),
            ),
          ),
    //Expanded(child: Restaurant != null ? Container(child: miMenu(),padding: EdgeInsets.symmetric(horizontal: 5),): Container(),),
    Container(child: Center(child: Text('Mensajes', style: Estiloletrasbdj))),
    Restaurant != null
        ? AddColonias(
            id_Restaurant: Restaurant.id_Restaurant,
          )
        : Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _sTitulo = sCambioTitulo(_selectedIndex);
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _sTitulo,
          style: EstiloletrasTitulo,
        ),
        actions: _selectedIndex == 3
            ? [
                iBusquedaCol(context),
              ]
            : null,
      ),
      drawer: DrawerRest(),
      body: Column(
        children: [
          Expanded(child: tabs[_selectedIndex]),
        ],
      ),
      //floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(child: Icon(Icons.fastfood,color: ColorBtnTxt,), onPressed: (){ setState(() { MenuAddShow(context); }); }, ): null,
      floatingActionButton: _selectedIndex == 0
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              AnimatedContainer(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _bigger ? Colors.redAccent : Colors.blueAccent,
                        ColorFondoApp
                      ],
                      //stops: [ _bigger ? 0.2 : 0.5, 1.0]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  duration: Duration(microseconds: 1),
                  curve: Curves.easeInOutQuint,
                  //child: FloatingActionButton(child: Icon(Icons.arrow_downward_outlined,color: ColorBtnTxt,size: _bigger ? 40: 20,),heroTag: 'btn1'),
                  child: Icon(
                    Icons.arrow_downward_outlined,
                    color: _bigger ? Colors.blueAccent : Colors.redAccent,
                    size: 60,
                  )),
              //FloatingActionButton(child: Icon(Icons.arrow_downward_outlined,color: ColorBtnTxt,size:40,),heroTag: 'btn1',),
              Flexible(
                child: SizedBox(
                  height: _bigger ? 20 : 5,
                ),
              ),
              FloatingActionButton(
                child: Icon(
                  Icons.fastfood,
                  color: ColorBtnTxt,
                ),
                heroTag: 'btn2',
                onPressed: () {
                  setState(() {
                    MenuAddShow(context);
                  });
                },
              ),
            ])
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            title: Text('Pedidos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            title: Text('Mensajes'),
          ),
        ],
        currentIndex: _selectedIndex != 3 ? _selectedIndex : 0,
        selectedItemColor: ColorSelect,
        unselectedItemColor: ColorAppMat,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  String sCambioTitulo(int nindex) {
    switch (nindex) {
      case 0:
        return sNomApp;
      case 1:
        return "Pedido";
      case 2:
        return "Mensajes";
      case 3:
        return sNomApp;
    }
    return "";
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _timer.cancel();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_selectedIndex != 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _bigger = !_bigger;
          });
        }
      },
    );
  }

  Future<void> ViewColonias(int id_Restaurant) async {
    AddColoniaRestaurant(context, id_Restaurant);

    /*
    ColoniasModel Colonias = ColoniasModel();

    final response = await http.get('${sURL}Login/Restaurant/${id_Restaurant}');
    print("Estatus: ${response.statusCode}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jSon = json.decode(response.body);
      Colonias = ColoniasModel.fromJson(jSon[0]);

      AddColoniaRestaurant(context, id_Restaurant);
    }*/
  }
}

class SineCurve extends Curve {
  final double count;

  SineCurve({this.count = 1});

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t) * 0.5 + 0.5;
  }
}
