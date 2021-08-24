import 'dart:convert';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/RestaurantModel.dart';
import 'MiVariablesGlobales.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;

Future<RestaurantModel> RestaurantView(int id_Usuario) async {
  //final response = await http.get('${sURL}Login/Restaurant/${id_Usuario}');
  final response =
      await http.get(CadenaConexion('Login/Restaurant/${id_Usuario}'));
  print("Estatus: ${response.statusCode}");
  if (response.statusCode == 201 || response.statusCode == 200) {
    var jSon = json.decode(response.body);
    return RestaurantModel.fromJson(jSon[0]);
  } else {
    return null;
  }
}

Future<RestaurantModel> UpdateRestaurante() async {
  String img64 = '';
  if (imageFile != null) img64 = base64Encode(imageFile.readAsBytesSync());
  //final response = await http.post('${sURL}Restaurante/UpdateRestaurant', body: {
  final response =
      await http.post(CadenaConexion('Restaurante/UpdateRestaurant'), body: {
    //                                      Restaurant
    'id_Restaurant': Restaurant.id_Restaurant.toString(),
    'id_usuario': user.id.toString(),
    'Nombre': ctrl.txtNombreEmp.text,
    'Descripcion': ctrl.txtDescripcionEmp.text,
    'TipoCategoria': ctrl.txtTipoCategoriaEmp.text,
    'TipoRestaurant': ctrl.txtTipoRestaurantEmp.text,
    'Telefono': ctrl.NoCelEmp.text,
    'Domicilio': ctrl.txtDomicilioEmp.text,
    'Sector': '0', //ctrl.txtSectorEmp.text,
    'DiasLaborales': ctrl.txtDiasLaboralesEmp.text,
    'TipoServ': ctrl.txtTipoServEmp.text,
    'horario': ctrl.txtHorarioEmp.text,
    'logo': img64, //sImagen(imageFile),
    'Latitud': dLatitud.toString(),
    'Longitud': dLongitud.toString(),
  });
  print("Estatus: ${response.statusCode}");
  if (response.statusCode == 201 || response.statusCode == 200) {
    var jSon = json.decode(response.body);
    return RestaurantModel.fromJson(jSon[0]);
  } else {
    return null;
  }
}
