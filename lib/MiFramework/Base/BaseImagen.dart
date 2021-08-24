import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:flutter/cupertino.dart';

class BaseImagen extends StatefulWidget{
  final String sFoto;
  final int nOpcion;
  /*
  * 0: Es para imagen de Busqueda Detalle
  * 1: Es para imagen de detalles dle menu
  * */

  const BaseImagen({Key key, this.sFoto, this.nOpcion}) : super(key: key);
  @override
  BaseImagenState createState() => BaseImagenState();
}

class BaseImagenState extends State<BaseImagen>{
  @override
  Widget build(BuildContext context) {
    switch (widget.nOpcion) {
      case 0:
        return Container(height: 200.0, width: 130.0,
                         decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                                                   image: DecorationImage(image: Imagen(widget.sFoto))),
                        );
      break;
      case 1:
        return Container(height: 97.0, width: 130.0,
                         decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                                                   image: DecorationImage(image: Imagen(widget.sFoto))),
                        );
      break;
      case 3:
        return Container(height: 300.0, width: 100.0,
                         decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0)),
                                                   image: DecorationImage(image: Imagen(widget.sFoto))),
                        );
      break;
    }
  }

}