import 'package:dartxero/MiFramework/Base/BaseImagen.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miMenu.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaPlatillos extends StatefulWidget{
  final int id_Restaurant;

  const BusquedaPlatillos({Key key, this.id_Restaurant}) : super(key: key);
  @override
  BusquedaPlatillosState createState() => BusquedaPlatillosState();

}

class BusquedaPlatillosState extends State<BusquedaPlatillos>{

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(context, data[index]);
          //return Text(data[index].Nombre);
        });
  }

  Container _tile(context, data) => Container(
      padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
      //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 1,),borderRadius: BorderRadius.circular(10),),
      child: Row(children: [
        Container(
          child: BaseImagen(sFoto: data.menufoto,nOpcion: 1,)
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
            width: 70,
          ),
        ),
        SizedBox(
          width: 25,
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
        ),
      ])
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        FutureBuilder<List<MenuModel>>(
          future: MenuView(widget.id_Restaurant, 0, 0), //MenuView(),
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
    );
  }

}