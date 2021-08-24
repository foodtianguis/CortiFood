import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:http/http.dart';

Future<void> PedidoCarritoDetalle(int id_usuario, int id_CarritoDetalle) async {
  //final repose = await post("${sURL}Carrito/CompraDetalle/${id_usuario}/${id_CarritoDetalle}");
  final repose = await post(CadenaConexion(
      "Carrito/CompraDetalle/${id_usuario}/${id_CarritoDetalle}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
  } else {
    throw Exception("Fallo!");
  }
}

Future<void> PedidoCarrito(int id_usuario, int id_Carrito) async {
  //final repose = await post("${sURL}Carrito/CompraCarrito/${id_usuario}/${id_Carrito}");
  final repose = await post(
      CadenaConexion("Carrito/CompraCarrito/${id_usuario}/${id_Carrito}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
  } else {
    throw Exception("Fallo!");
  }
}

Future<void> PedidoMenu(
    int id_usuario, int id_menu, int Cantidad, String Comentarios) async {
  /*final repose = (Comentarios != "") ?
      await post("${sURL}Carrito/ComprarMenu/${id_usuario}/${id_menu}/${Cantidad}/${Comentarios}")
      :await post("${sURL}Carrito/ComprarMenuSin/${id_usuario}/${id_menu}/${Cantidad}");*/
  final repose = (Comentarios != "")
      ? await post(CadenaConexion(
          "Carrito/ComprarMenu/${id_usuario}/${id_menu}/${Cantidad}/${Comentarios}"))
      : await post(CadenaConexion(
          "Carrito/ComprarMenuSin/${id_usuario}/${id_menu}/${Cantidad}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
  } else {
    throw Exception("Fallo!");
  }
}

Future<void> PedidoMenuUbi(
    int id_usuario,
    int id_menu,
    int Cantidad,
    String Comentarios,
    String Direccion,
    String Cp,
    String Colonia,
    double Latitud,
    double Longitud,
    int id_Localidad,
    int id_ComisionEnvio,
    String Referencia) async {
  Object body = {
    'id_usuario': id_usuario.toString(),
    'id_menu': id_menu.toString(),
    'Cantidad': Cantidad.toString(),
    'Comentarios': Comentarios,
    'Direccion': Direccion,
    'Cp': Cp,
    'Colonia': Colonia,
    'Latitud': Latitud.toString(),
    'Longitud': Longitud.toString(),
    'id_Localidad': id_Localidad,
    'id_ComisionEnvio': id_ComisionEnvio,
    'Referencia': Referencia
  };
  final repose = (Comentarios != "")
      ?
      //await post(CadenaConexion("Carrito/ComprarMenuUbi/${id_usuario}/${id_menu}/${Cantidad}/${Comentarios}/${Direccion}/${Cp}/${Latitud}/${Longitud}"))
      //:await post(CadenaConexion("Carrito/ComprarMenuSinUbi/${id_usuario}/${id_menu}/${Cantidad}/${Direccion}/${Cp}/${Latitud}/${Longitud}")
      await post(CadenaConexion("Carrito/ComprarMenuUbi"), body: body)
      : await post(CadenaConexion("Carrito/ComprarMenuSinUbi"), body: body);
  if (repose.statusCode == 200 || repose.statusCode == 201) {
  } else {
    throw Exception("Fallo!");
  }
}
