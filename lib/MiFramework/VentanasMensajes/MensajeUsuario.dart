import 'package:dartxero/Acciones/Pedidos/AccionPedido.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/CarritoModel.dart';
import 'package:flutter/material.dart';

void RealizaCompra(BuildContext bContext, CarritoModel Carrito){
  DialogSys(
    bContext,
    Container(
      height: 350,
      child: Column(
        children: [
          Container(
            height: 200.0, width: double.maxFinite,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)), //color: Colors.cyanAccent,
                image: DecorationImage(image: Imagen(Carrito.menufoto))
            ),
          ),
          SizedBox(height: 10,),
          Text(Carrito.menuNombre, style: TextStyle(fontWeight: FontWeight.bold),),
          Row(
            children: [
              SizedBox(child: Text(sCantidad),width: 80,),
              Text(":   "),
              Container(child: Text("${Carrito.CarritoDetalleCantidad}"),width: 80,alignment: Alignment.centerRight,),
            ],
          ),
          Row(
            children: [
              SizedBox(child: Text(sPrecio),width: 80,),
              Text(": \$"),
              Container(child: Text("${Carrito.menuPrecio}0"),width: 80,alignment: Alignment.centerRight,),
            ],
          ),
          Row(
            children: [
              SizedBox(child: Text(sComision),width: 80,),
              Text(": \$"),
              Container(child: Text("3.00"),width: 80,alignment: Alignment.bottomRight,),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(child: Text(sTotal),width: 80,),
              Text(": \$"),
              Container(child: Text("${(Carrito.menuPrecio * Carrito.CarritoDetalleCantidad)+3}0"),width: 80,alignment: Alignment.bottomRight,),
            ],
          ),
          SizedBox(height: 20,),
          Row(children: [
            SizedBox(width: 10,),
            GestureDetector(
                child: Link(sConfirma),
                onTap: () {
                  PedidoCarritoDetalle(Carrito.Carritoid_Usuario, Carrito.CarritoDetalleid_CarritoDetalle);
                  Navigator.pushReplacementNamed(bContext, '/BandejaUserCarrito');
                  //Navigator.pop(bContext);
                }
            ),
            SizedBox(width: 20,),
            GestureDetector(
                child: Link(sCancelar),
                onTap: () {
                  Navigator.pop(bContext);
                }
            ),
          ],
          ),
        ],
      ),
    ),
  );
}

void DialogSys(BuildContext bContext, Container Cont){
   showDialog(
      context: bContext,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(
                        Icons.close,
                      ),
                      backgroundColor: Colors.red,
                      radius: 15,
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Cont,
                ),
              ],
            )
        );
      });
}


