import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;

import 'MiEstilos.dart';

class ComboBox extends StatefulWidget{
  final int nTipo;

  const ComboBox({Key key, this.nTipo}) : super(key: key);
  @override
  _ComboBox createState() => _ComboBox(nTipo);
}

class _ComboBox extends State<ComboBox> {
  final int nTipo;
  String dropdownValue = 'AM';
  List <ListItem> _Horario = [
    ListItem ("AM", "AM"),
    ListItem ("PM", "PM"),
  ];
  _ComboBox(this.nTipo);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      //icon: Icon(Icons.arrow_downward),
     // iconSize: 24,
      elevation: 0,
      style: TextStyle(fontSize: 10.0, color: ColorLabel),
      underline: Container(
        height: 0,
        color: ColorFondoApp,
        //decoration: Decoration(),
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          switch (nTipo){
            case 0: sEntradaAMPM = newValue;
            break;
            case 1: sSalidaAMPM = newValue;
            break;
          }
        });
      },
      items: <String>['AM', 'PM']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class ListItem {
  String value;
  String name;

  ListItem(this.value, this.name);
}


class comboboxDos extends StatefulWidget {
  final int nTipo;
  final String Selec;
  final int nTipoAccion;

  const comboboxDos({Key key, this.nTipo, this.Selec, this.nTipoAccion}) : super(key: key);
  @override
  _comboboxDos createState() => _comboboxDos(nTipo, Selec, nTipoAccion);
}

class _comboboxDos extends State<comboboxDos> {
  final int nTipo;
  final String Selec;
  final int nTipoAccion;
  //                  0
  List<ListItem> _TipoCategoria = [
    ListItem("1","Desayunos"),
    ListItem("2","Comidas Corridas"),
    ListItem("3","Bebidas"),
    ListItem("4","Mariscos"),
    ListItem("5","Comida Rapida"),
    ListItem("6","Postres"),
    ListItem("7","Comida China"),
    ListItem("8","Comida Japonesa"),
    ListItem("9","Comida Callejera")
  ];
  //                1 y 2
  List<ListItem> _Horario = [
    ListItem("AM", "AM"),
    ListItem("PM", "PM")
  ];
  //                3
  List<ListItem> _TipoServicio = [
    ListItem("dom", "Domicilio"),
    ListItem("lle", "Ordenar para llevar")
  ];
  //                1
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  _comboboxDos(this.nTipo, this.Selec, this.nTipoAccion);

  void initState() {
    super.initState();
    switch (nTipo) {
      case 0:
        _dropdownMenuItems = buildDropDownMenuItems(_TipoCategoria);
        break;
      case 1:
        _dropdownMenuItems = buildDropDownMenuItems(_Horario);
      break;
      case 2:
        _dropdownMenuItems = buildDropDownMenuItems(_Horario);
        break;
    }
    if (Selec == '') {
      _selectedItem = _dropdownMenuItems[0].value;
    }else {
      for (int i = 0; i <= _dropdownMenuItems.length - 1; i++)
        if (_dropdownMenuItems[i].value.value == Selec) {
          _selectedItem = _dropdownMenuItems[i].value;
        }
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
                switch (nTipo) {
                  case 0:
                    ctrl.txtTipoCategoriaEmp.text = _selectedItem.value;
                    if (nTipoAccion == 2){
                      setState(() {
                        ValidaRest.TipoCategoria = ctrl.txtTipoCategoriaEmp.text != Restaurant.TipoCategoria;
                        bModifica = ModificaCampos(1);
                      });
                    }
                    break;
                  case 1:
                    sEntradaAMPM = _selectedItem.value;
                    if (nTipoAccion == 2) {
                      setState(() {
                        ValidaRest.AM = sEntradaAMPM != ctrl.txtAM.text;
                        bModifica = ModificaCampos(1);
                      });
                    }
                    break;
                  case 1:
                    sSalidaAMPM = _selectedItem.value;
                    if (nTipoAccion == 2) {
                      setState(() {
                        ValidaRest.PM = sSalidaAMPM != ctrl.txtPM.text;
                        bModifica = ModificaCampos(1);
                      });
                    }
                    break;
                }
              });
            });
  }
}
