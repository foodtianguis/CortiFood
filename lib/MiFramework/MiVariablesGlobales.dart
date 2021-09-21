import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dartxero/MiModel/NotifiModel.dart';
import 'package:dartxero/MiModel/UbicacionModel.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:dartxero/MiModel/RestaurantModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

MyPreferences _myPreferences = MyPreferences();
SharedPreferences sharedPreferences;
NotifiModel NotificacionLocal = new NotifiModel();

LocaleType ConfLocal = LocaleType.es;
Image FotoUser = Image.asset(
  'Utilerias/Imagen/User.png',
  height: 250,
  width: 250,
);

String sLogoPerfilDefault = 'Utilerias/Imagen/Cortifood.png';
String sLogoMap = 'Utilerias/Imagen/gulaLetrasMap.png';

//                  Loguin
String sUsuarioGLB;
String sPassGLB;

bool bLogueado;
bool bRecorUser = _myPreferences.automatic;
String sJsonVacio = '['
    '{'
    '    "id": 0,'
    '   "Nickname": "Invitado",'
    '    "NumCel": "0",'
    '   "Pass": "123",'
    '    "Activo": "ACTIVO",'
    '    "LoginFacebook": false,'
    '    "TipoUsuario": 5,'
    '    "Nombre": "Invitado",'
    '    "Apellido": "",'
    '    "FechaNac": "2000-01-01",'
    '    "FechaReg": "2000-01-01",'
    '    "TipoPreferencia": 0,'
    '   "Calle": null,'
    '    "cp": null,'
    '    "Colonia": null,'
    '    "numExt": 0,'
    '    "numInt": 0,'
    '    "Ciudad": null,'
    '    "foto": ""'
    '}'
    '] ';
var dUsuarioGLB = json.decode(sJsonVacio.trim());
//
//                modelos
//
UserModel user;
MenuModel Menu;
RestaurantModel Restaurant;
UbicacionModel UbicacionUsuario;
//

ValCampoRestaurante ValidaRest = ValCampoRestaurante();
ValCampoMenu ValidaMenu = ValCampoMenu();
ValCampoUser ValidaUser = ValCampoUser();
bool bModifica;
Drawer dwInicio = Drawer();
String BASE64_STRING;
String SinImagen =
    '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';
//String SinImagen = '';

bool ModificaCampos(int nControl) {
  // 1 Restaurante, 2 Menu y 3 Usuario
  switch (nControl) {
    case 1:
      return ValidaRest.Nombre ||
          ValidaRest.Descripcion ||
          ValidaRest.TipoCategoria ||
          ValidaRest.TipoRestaurant ||
          ValidaRest.Telefono ||
          ValidaRest.Domicilio ||
          ValidaRest.Sector ||
          ValidaRest.DiasLaborales ||
          ValidaRest.TipoServ ||
          ValidaRest.horario1 ||
          ValidaRest.horario2 ||
          ValidaRest.AM ||
          ValidaRest.PM ||
          ValidaRest.logo ||
          ValidaRest.Ubica;
      break;
    case 2:
      return ValidaMenu.Nombre ||
          ValidaMenu.Descripcion ||
          ValidaMenu.TipoCategoria ||
          ValidaMenu.Precio ||
          ValidaMenu.Extras ||
          ValidaMenu.foto;
      break;
    case 3:
      return ValidaUser.Nombre ||
          ValidaUser.Apellido ||
          ValidaUser.FechaNac ||
          ValidaUser.cp ||
          ValidaUser.NumCel ||
          ValidaUser.foto ||
          ValidaUser.Calle ||
          ValidaUser.Ciudad ||
          ValidaUser.Colonia ||
          ValidaUser.numExt ||
          ValidaUser.numInt ||
          ValidaUser.TipoPreferencia;
      break;
  }
}

bool IniRestaurant = false;
int iTipoVal = 0;
File imageFile;
File imageFileM;
String ConvImageString = '';
ByteData ImagenByte;
String base64Image;
DateTime sFechaNacCont;
bool bLoguinFacebook = false;
int iTipoUsuario = 0;
Location locationGLB;
LocationData currentLocationGLB;

double dLatitud;
double dLongitud;

/*
    Refresh global
*/
var listaGlb;
var randomGlb = Random();
var refreshKeyGlb = GlobalKey<RefreshIndicatorState>();

Future<Null> refreshListGlb() async {
  refreshKeyGlb.currentState?.show();
  await Future.delayed(Duration(seconds: 1));
  listaGlb = List.generate(randomGlb.nextInt(10), (i) => "Item $i");
  return null;
}

String sEntradaAMPM = "AM";
String sSalidaAMPM;
Map<int, Color> color = {
  100: Color(0xFFB9F6CA),
  200: Color(0xFF69F0AE),
  400: Color(0xFF00E676),
  700: Color(0xFF00C853),
};

//                Color App
final Color ColorApp = Colors.grey[200];

final MaterialColor ColorAppMat = Colors.deepOrange;

final Color ColorFondoApp = Colors.white;
final Color ColorFondo = Colors.black12;
//                Colores de componentes
final Color ColorLabel = Colors.orange[900];
final Color ColorDescr = Colors.grey;

//                boton                       //
//final Color ColorBoton = Colors.green;
final Color ColorBoton = ColorApp;
final Color ColorBtnTxt = Colors.orange[900];
final IconThemeData ColorBtnTxtTheme = IconThemeData(color: ColorBtnTxt);

final Color ColorSelect = Colors.orange[900];
final Color splashBtn = Colors.indigo;
//final Color disabledBth = Colors.green[100];
final Color disabledBth = Colors.grey[100];
//
//                Lineas                        //
final Color ColorLineas = ColorApp;
final Divider Separador = Divider(
  color: ColorLineas,
  height: 5,
  thickness: 5.0,
);
final Divider SeparadorCarrito = Divider(
  color: Colors.black12,
  height: 10,
  thickness: 0.1,
  indent: 10,
  endIndent: 10,
);
final Divider SeparadorFit = Divider(
  color: Colors.black12,
  height: 10,
  thickness: 2,
);
//                                              //
//                  Estilos de Titulos
final TextStyle EstiloTitulos =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ColorLabel);
final TextStyle Estiloletrasbdj =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorLabel);
final TextStyle EstiloletrasTitulo = TextStyle(
  fontSize: 30.0,
  color: ColorBtnTxt,
);
final TextStyle EstiloletrasPestana = TextStyle(
  fontSize: 15.0,
  color: ColorBtnTxt,
);
//
//                  Estilo de Letra
final TextStyle EstiloLetraLB = TextStyle(fontSize: 15.0, color: ColorLabel);
final TextStyle EstiloLetraLBDes =
    TextStyle(fontSize: 15.0, color: Colors.black12);
final TextStyle EstiloLetraLBchico =
    TextStyle(fontSize: 15.0, color: ColorLabel);
final TextStyle EstiloLetraBtn = TextStyle(fontSize: 20.0, color: ColorBtnTxt);
final TextStyle EstiloLetraBtnchico =
    TextStyle(fontSize: 15.0, color: ColorBtnTxt);
final TextStyle EstiloLetraDrawer =
    TextStyle(fontSize: 15.0, color: ColorFondoApp);
final TextStyle EstiloLink =
    TextStyle(decoration: TextDecoration.underline, color: Colors.blue);
final TextStyle EstiloLetraError = TextStyle(fontSize: 15.0, color: Colors.red);

final Checkbox cb = Checkbox();
//

//                  Estilo de Fechas
final TextStyle estiloFechas =
    TextStyle(color: ColorApp, fontWeight: FontWeight.bold, fontSize: 18.0);
final Icon iFechas = Icon(
  FontAwesomeIcons.calendarWeek,
  size: 18.0,
  color: ColorBoton,
);
//
//                              Configuracion Redes Sociales
final Color ColorLabelFace = Colors.white;
final Color ColorBtnFace = Colors.indigoAccent;
final TextStyle EstiloFacebookBtn =
    TextStyle(fontSize: 15.0, color: ColorLabelFace);
//

//                        Mensajes
final String sNomApp = 'CortiFood';

//                        Mensajes Loguin
//                  Direccion ip URL de conexion
final String sIP = '74.208.35.164';
//final String sIP = 'localhost';
final String sURL = 'http://${sIP}/Cortifood/';
final String sApiKey = 'AIzaSyC0oJ2-IUW_yU9mNU85lu_pq0mMVAFyLTI';
//final String sURL = 'http://${sIP}';
//

final String sNomUser =
    'Número Telefonico'; //'Nombre de Usuario o Número Telefonico';
final String sNomUserEmp = 'Usuario Empresarial';
final String sPassword = 'Contraseña';
final String sPasswordConf = 'Confirmar Contraseña';
final String sEntrar = "Entrar";

final String sNombre = "Nombre";
final String sApellido = "Apellido";
final String sFechaNac = "Fecha de Nacimiento";
final String sCelular = "No. de Celular";
final String sCP = "Código Postal";
final String sCalle = "Calle";
final String sColonia = "Colonia";
final String sCiudad = "Ciudad";
final String sFoto = "Foto";
final String sNumInt = "No. Int";
final String sNumExt = "No. Ext";
//                  Restaurant
final String sNomRestauran = "Nombre Restaurant";
final String sDescripcion = "Descripción";
final String sTelefono = "Telefono";
final String sDomicilio = "Domicilio";
//
//                  Mensaje Sistema
final String sMensajeErrorLoguin = "Revisar:\n\nUsuario y Contraseña";
final String sErrorIngrese = 'Ingrese: ';
final String msjAceptar = 'Aceptar';
String msjCreo(int nTipo, String nick) {
  switch (nTipo) {
    case 1:
      return 'Se creo Usuario: ${nick}';
      break;
    case 2:
      return 'Se creo Restaurante: ${nick}';
      break;
  }
}

final String sMenuVacio =
    'Aumenta tus ventas ingresando tu menú'; //'''Menú Vacio';

final String sSiguiente = 'Siguiente';
final String sConfirma = 'Confirmar';
final String sGuardar = 'Guardar';
final String sMensaje = 'Mensaje';
final String sComprar = 'Comprar';
final String sAddCarrito = 'Agregar Carrito';
final String sCantidadzero = "Cantidad en 0";
final String sVpedido = "Ver Pedido";
final String sAyuda = 'Ayuda';
final String sMiDatos = 'Mis Datos';
final String sMiRestaurant = 'Mi Restaurant';
final String sConfig = 'Configuración';
final String sRuta = 'Ruta';
final String sRecUser = 'Recordar Usuario';

//===========================Datos Tarjeta========================//
const String sNumero = 'Número';
const String sNumeroTarjeta = 'Número de Tarjeta';
const String sFechaVen = 'MM/YY';
const String sCVV = 'CVV';
const String sNombreTitular = 'Nombre Titular';
const String sAlias = 'Alias';
const String cvvValidationMessage = 'Ingrese el CVV Valido';
const String dateValidationMessage = 'Ingrese la Fecha Valida';
const String numberValidationMessage = 'Ingrese Número de Tarjeta Valido';
//===============================================================//
final String sRegis = 'Registrarse';
final String sRegisEmpresa = 'Registrar Restaurante';
final String sRegisFace = "Registrate con Facebook";
//========================== Sistema ============================//
final String sCerrarSecion = 'Cerrar Sesión';
final String sInicSecion = 'Inicie Sesión';
final String sSalir = 'Salir';
final String sCancelar = 'Cancelar';
final String sDetalles = 'Detalles';
final String sComision = 'Comisión';
final String sComisionApp = 'Comisión App';
final String sTotal = 'Total';
final String sCantidad = "Cantidad";
final String sNota = "Nota";
final String sPrecio = "Precio";
final String sReferencia = "Referencia";
//========================= Sistema : ============================//
final String sComision2Pt = 'C. Apps :';
final String sCantidad2Pt = 'Cantidad :';
final String sDireccion2Pt = 'Dirección :';
final String sTotal2Pt = 'Total :';
//
final String sSelecImg = "Seleccionar Imagen";
final String sSelecImgQuest = "¿Seleccionar imagen de?";
final String sGaleria = "Galeria";
final String sCamara = "Camara";

//
//            Icon User
Icon iMsj = Icon(FontAwesomeIcons.envelope);
Icon iHlp = Icon(FontAwesomeIcons.lifeRing);
Icon iMDs = Icon(FontAwesomeIcons.userCircle);
Icon iRes = Icon(Icons.apartment_outlined);
Icon iConf = Icon(Icons.settings);
Icon iRuta = Icon(Icons.bus_alert);
Icon iSrch = Icon(FontAwesomeIcons.search);
Icon iBack = Icon(FontAwesomeIcons.chevronLeft);

Icon iSalir = Icon(FontAwesomeIcons.timesCircle);
Icon iCerrarSecion = Icon(FontAwesomeIcons.signOutAlt);
Icon iInicSecion = Icon(FontAwesomeIcons.signInAlt);
Icon iError = Icon(
  FontAwesomeIcons.timesCircle,
  color: Colors.red,
);

Icon iAddCarrito =
    Icon(FontAwesomeIcons.cartPlus, color: ColorBtnTxt, size: 30.0);
Icon iCarrito = Icon(FontAwesomeIcons.shoppingCart);
Icon iUbica = Icon(FontAwesomeIcons.mapMarkerAlt);
Icon iUbicaSys = Icon(Icons.location_on);
//
///          Icon Restaurant
///
Icon iPedidos = Icon(Icons.local_offer);

///
///
///

//                    Meses
final String sEnero = 'Enero';
final String sFebrero = 'Febrero';
final String sMarzo = 'Marzo';
final String sAbril = 'Abril';
final String sMayo = 'Mayo';
final String sJunio = 'Junio';
final String sJulio = 'Julio';
final String sAgosto = 'Agosto';
final String sSeptiembre = 'Septiembre';
final String sOctubre = 'Octubre';
final String sNoviembre = 'Noviembre';
final String sDiciembre = 'Diciembre';

var sDiasSemana = <String>[
  "Lunes",
  "Martes",
  "Miercoles",
  "Jueves",
  "Viernes",
  "Sabado",
  "Domingo",
];
var sTipoOrden = <String>["Domicilio", "Ordenar para llevar"];
//

//                    Tipo de Categorias
List<Icon> IconCategoria = [
  Icon(FontAwesomeIcons.hamburger,
      color: disabledBth, size: 30.0), // Hamburguesa
  Icon(FontAwesomeIcons.pizzaSlice, color: disabledBth, size: 30.0), // Pizza
  Icon(FontAwesomeIcons.fish, color: disabledBth, size: 30.0), // Mariscos
  Icon(FontAwesomeIcons.birthdayCake,
      color: disabledBth, size: 30.0), // Postres
  Icon(FontAwesomeIcons.pepperHot, color: disabledBth, size: 30.0), // Comida
];
final String sHamburger = 'Hamburguesa';
Icon iHamburger =
    Icon(FontAwesomeIcons.hamburger, color: disabledBth, size: 30.0);
final String sPizza = 'Pizza';
Icon iPizza = Icon(FontAwesomeIcons.pizzaSlice, color: disabledBth, size: 30.0);
final String sCoffee = 'Café';
Icon iCoffee = Icon(FontAwesomeIcons.coffee, color: disabledBth, size: 30.0);
final String sMarisco = 'Mariscos';
Icon iMariscos = Icon(FontAwesomeIcons.fish, color: disabledBth, size: 30.0);
final String sBebidas = 'Bebidas';
Icon iBebidas =
    Icon(FontAwesomeIcons.wineBottle, color: disabledBth, size: 30.0);
final String sHotDog = 'Hot Dogs';
Icon iHotDog = Icon(FontAwesomeIcons.hotdog, color: disabledBth, size: 30.0);
final String sCake = 'Postres';
Icon iCake =
    Icon(FontAwesomeIcons.birthdayCake, color: disabledBth, size: 30.0);
//Icon iHamburguer = Icon(FontAwesomeIcons.hamburger,color: disabledBth,size: 30.0);
//Icon iHamburguer = Icon(FontAwesomeIcons.hamburger,color: disabledBth,size: 30.0);
//Icon iHamburguer = Icon(FontAwesomeIcons.hamburger,color: disabledBth,size: 30.0);
//
