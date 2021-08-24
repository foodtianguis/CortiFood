import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MiVariablesGlobales.dart';

BoxDecoration esMarcoFotos = BoxDecoration(border: Border.all(color: ColorLineas,width: 0.5,),/*borderRadius: BorderRadius.circular(30),*/);
BoxDecoration esMarcoBox = BoxDecoration(border: Border.all(color: ColorLineas,width: 0.5,));

//        Decoraciones de caja de textos
InputDecoration InpDecoTxt (String sTitulo){
  return InputDecoration(labelText: sTitulo, /*border: OutlineInputBorder()*/);
}

Text sTituloschico(sTitulo){
  return Text(sTitulo,style: TextStyle(fontSize: 12.0, color: ColorLabel),);
}