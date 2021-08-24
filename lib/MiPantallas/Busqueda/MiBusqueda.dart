import 'dart:convert';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';

Future<List<BusquedaModel>> BusquedaView(String sBusqueda) async {
  //final repose = await http.get("${sURL}Busqueda/Categoria/${sBusqueda}");
  final repose = await http.get(CadenaConexion("Busqueda/Categoria/${sBusqueda}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => BusquedaModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}

Future<BusquedaModel> BusquedaViewDetalle(int nMenu) async {
  //final repose = await http.get("${sURL}Busqueda/Menu/${nMenu}");
  final repose = await http.get(CadenaConexion("Busqueda/Menu/${nMenu}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    return BusquedaModel.fromJson(json.decode(repose.body)[0]);
  } else {
    throw Exception("Fallo!");
  }
}