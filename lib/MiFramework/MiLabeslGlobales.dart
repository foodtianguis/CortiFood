import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'MiAcciones.dart';


class PassLabels extends StatelessWidget {
  final String sTitulo;
  final TextEditingController txtController;
  const PassLabels({Key key, this.sTitulo, this.txtController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: sTitulo,
      ),
      style: EstiloLetraLB,
      obscureText: true,
      controller: txtController,
    );
  }
}

class UsersLabels extends StatelessWidget {
  final String sTitulo;
  final TextEditingController txtController;
  const UsersLabels({Key key, this.sTitulo, this.txtController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: sTitulo),
      style: EstiloLetraLB,
      controller: txtController,
    );
  }
}

class GenericLabels extends StatelessWidget {
  final String sTitulo;
  final TextEditingController txtController;
  const GenericLabels({Key key, this.sTitulo, this.txtController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: sTitulo),
      style: EstiloLetraLB,
      controller: txtController,
    );
  }
}

class GenericLabelsVal extends StatefulWidget {
  final String sTitulo;
  final TextEditingController txtController;
  final int TipoVal;
  const GenericLabelsVal({Key key, this.sTitulo, this.txtController, this.TipoVal}) : super(key: key);
  @override
  _GenericLabelsVal createState() => new _GenericLabelsVal(sTitulo, txtController, TipoVal);
}

//class GenericLabelsVal extends StatelessWidget {
class _GenericLabelsVal extends State<GenericLabelsVal> {
  final String sTitulo;
  final TextEditingController txtController;
  final int TipoVal;

  _GenericLabelsVal(this.sTitulo, this.txtController, this.TipoVal);
  @override
  void initState() {
    super.initState();
    setState(() {
      iTipoVal = TipoVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(hintText: sTitulo),
    style: EstiloLetraLB,
    controller: txtController,
    obscureText: true,
    validator: Validacion,
    );
  }
}
