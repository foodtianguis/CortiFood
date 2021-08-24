import 'package:dartxero/MiFramework/MiAccionLogin.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiPantallas/Busqueda/BusquedaDetalle.dart';
import 'package:dartxero/MiPantallas/Busqueda/MiBusqueda.dart';
import 'package:dartxero/MiPantallas/Carrito/AddCarrito.dart';
import 'package:dartxero/MiUtilidad/stepper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Search extends SearchDelegate{
  //final List<String> listExample;
  String sBusqueda = "Buscar";
  Search() : super(
    searchFieldLabel: "Buscar",
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );
  String sResult = "";
  String sQuery  = "";
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[IconButton(icon: Icon(Icons.close), onPressed: (){query = "";},)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back_outlined),onPressed: () => Navigator.pop(context),);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(child: query != ''? BusquedaList(query): null,);
  }

  List<String> recentList = ["Text 4","Text 3"];
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    //sQuery.isEmpty ? suggestionList = recentList: suggestionList.addAll(listExample.where((element) => element.contains(sQuery)));
    return ListView.builder(itemBuilder: (context, index){
      return ListTile(
        title: Text(
          suggestionList[index],
        ),
        leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
        onTap: () {
          sResult = suggestionList[index];
          showResults(context);
        },

      );
    },
      itemCount: suggestionList.length,

    );
  }

  ListView BusquedaList(String sBusqueda){
    return ListView(
        children: <Widget>[
          FutureBuilder<List<BusquedaModel>>(
            future: BusquedaView(sBusqueda), //MenuView(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<BusquedaModel> data = snapshot.data;
                if (data.length == 0)
                  return Container(child: Center(child: Text('Sin Resultados', style: EstiloLetraLB,),),padding: EdgeInsets.symmetric(vertical: 200),);
                else
                  return _jobsListView(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                heightFactor: 500,
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

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return RaisedButton(child: _tile(context, data[index]), color: ColorFondoApp,onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => BusquedaDetalle(Busqueda: data[index])));

          },);
        });
  }

  Container _tile(context, data) => Container(
        padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
        //decoration: BoxDecoration(border: Border.all(color: ColorLineas,width: 1,),borderRadius: BorderRadius.circular(10),),
        child: Row(children: [
          Container(
            child:
            data.menufoto != null ? Image(height: 97.0, width: 130.0, image:Imagen(data.menufoto), ) : Container(child: Center(child: Text('No Hay Foto',)), height: 97.0, width: 130.0,),
            //decoration: esMarcoFotos,
          ),
          Flexible(
            child: SizedBox(
              width: 10,
            ),
          ),
          Container(
            width: 115,
            child: Column(
              children: [
                Container(
                  width: 115,
                  child: Text(
                      data?.menuNombre?? '',
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
                    ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 115,
                  child: Text(
                      data?.menuDescripcion?? '',
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,),
                    ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 115,
                    child: Text('\$ ' + data.Precio.toString() + '0',),
                  ),
              ],
            ),
          ),
          Flexible(
            child: SizedBox(
              width: 5,
            ),
          ),
          SizedBox(
            width: 70,
            child: Container(
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40,),
                  //StepperTouch(initialValue: 1,onChanged: (int value) => print('new value $value'),),
                  SizedBox(height: 10,),
                  Text(data.TiendaAbierta == true? 'Abierto':'Cerrado',style: EstiloLetraLB,)
                ],
              ),
            ),
          ),
          Flexible(
            child: SizedBox(
              width: 5,
            ),
          ),
        ]
        )
  );


}