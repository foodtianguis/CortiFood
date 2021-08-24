import 'package:dartxero/Api/Api.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiPantallas/Carrito/ViewCarrito.dart';
import 'package:dartxero/MiUtilidad/MiCategorias.dart';
import 'package:dartxero/MiUtilidad/MiSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class BaseUsuario{

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  void _onItemTapped(int index) {
    _selectedIndex = index;
  }

  AppBar Titulo(BuildContext context){
    return AppBar(
      title: Text(sNomApp),
      actions: <Widget>[
        IconButton(
            icon: iSrch,
            onPressed:() {
              showSearch(context: context,delegate: Search());
            }),
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
          icon: Icon(Icons.shopping_cart_outlined),
          title: Text('Carrito'),
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
      currentIndex: _selectedIndex,
      selectedItemColor: ColorApp,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }
}