import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarraCateforias extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
   return ListView(
     scrollDirection: Axis.horizontal,
     padding: EdgeInsets.only(left: 10.0, right: 10.0),
     children: <Widget>[
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: iPizza,
                 shape: CircleBorder(),
                 fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sPizza, style: EstiloTitulos,)),
                 width: 80,
               height: 10,
               ),
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: IconCategoria[0],shape: CircleBorder(),fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sHamburger, style: EstiloTitulos,)),width: 80,height: 10,
             ),
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: iCoffee,shape: CircleBorder(),fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sCoffee, style: EstiloTitulos,)),width: 80,height: 10,
             ),
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: iMariscos,shape: CircleBorder(),fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sMarisco, style: EstiloTitulos,)),width: 80,height: 10,
             ),
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: iBebidas,shape: CircleBorder(),fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sBebidas, style: EstiloTitulos,)),width: 80,height: 10,
             ),
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: iHotDog,shape: CircleBorder(),fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sHotDog, style: EstiloTitulos,)),width: 80,height: 10,
             ),
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.only(top: 10.0),
         width: 80,
         child: Column(
           children: <Widget>[
             Container(
               child: RawMaterialButton(
                 onPressed: () {
                   //Navigator.pushReplacementNamed(context, '/pages/listarUsuarios');
                   //    Navigator.pop(context);
                 },
                 child: iCake,shape: CircleBorder(),fillColor: ColorFondoApp,
               ),
               height: 60,
             ),
             Container(child: Center(child: Text(sCake, style: EstiloTitulos,)),width: 80,height: 10,
             ),
           ],
         ),
       ),
     ],
   );
  }
}