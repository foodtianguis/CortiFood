import 'dart:convert';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/SubCategoriaModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;

class BaseSubCategoria extends StatefulWidget{
  final int VerTodos;
  final int Categoria;
  final int Seleccionada;
  final MenuModel menu;

  const BaseSubCategoria({Key key, this.VerTodos, this.Categoria, this.Seleccionada, this.menu}) : super(key: key);

  @override
  BaseSubCategoriaState createState() => BaseSubCategoriaState();
}


class BaseSubCategoriaState extends State<BaseSubCategoria> {
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  List<ListItem> _SubCategoria = [];

  Future<void> CargaItem(int VerTodos, int Categoria, int Seleccionada) async {
    List<SubCategoriaModel> lista = await SubCategoriaView(VerTodos,Categoria);
    _SubCategoria.clear();
    lista.forEach((element) {
      _SubCategoria.add(ListItem(element.id_SubCategoria, element.SubCatNombre));
    });

    setState(() {
      ComboBoxLocal(Seleccionada);
    });

  }

  DropdownButton<ListItem> ComboBoxLocal(int Seleccionada){
    _dropdownMenuItems = buildDropDownMenuItems(_SubCategoria);

    if (Seleccionada != null) {
      for (int i = 0; i <= _dropdownMenuItems.length - 1; i++)
        if (_dropdownMenuItems[i].value.value == Seleccionada) {
          _selectedItem = _dropdownMenuItems[i].value;
        }
    } else {
      _selectedItem = _dropdownMenuItems[0].value;
    }
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: sTituloschico(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ListItem>(
        style: EstiloLetraLB,
        underline: Container(
          height: 0,
          color: ColorApp,
        ),
        value: _selectedItem,
        items: _dropdownMenuItems,
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
            ctrl.txtPlaSubCategoria.text = _selectedItem.value.toString();
            /*if (ValidaMenu != null) {
              ValidaMenu.TipoCategoria = (value.value != widget.menu.TipoCategoria);
              bModifica = ModificaCampos(2);
            }*/
          });
        });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      CargaItem(widget.VerTodos, widget.Categoria, widget.Seleccionada);
    });
  }
}

Future<List<SubCategoriaModel>> SubCategoriaView(int nVerTodos, int nCategoria) async {
  //final repose = await http.get("${sURL}Utilidades/SubCategoria/${nVerTodos}/${nCategoria}");
  final repose = await http.get(CadenaConexion("Utilidades/SubCategoria/${nVerTodos}/${nCategoria}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => SubCategoriaModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}

mixin ComboSubCategoria on StatefulWidget {
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  List<ListItem> _SubCategoria = [];

  Future<void> CargaItem(int VerTodos, int Categoria, int Seleccionada) async {
    List<SubCategoriaModel> lista = await SubCategoriaView(VerTodos,Categoria);
    _SubCategoria.clear();
    lista.forEach((element) {
      _SubCategoria.add(ListItem(element.id_SubCategoria, element.SubCatNombre));
    });
    ComboBoxLocal(Seleccionada);
  }

  DropdownButton<ListItem> ComboBoxLocal(int Seleccionada){
    _dropdownMenuItems = buildDropDownMenuItems(_SubCategoria);

    if (Seleccionada != null) {
      for (int i = 0; i <= _dropdownMenuItems.length - 1; i++)
        if (_dropdownMenuItems[i].value.value == Seleccionada) {
          _selectedItem = _dropdownMenuItems[i].value;
        }
    } else {
      _selectedItem = _dropdownMenuItems[0].value;
    }
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: sTituloschico(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }


}


class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}