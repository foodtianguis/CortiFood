import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartxero/Maps/Map.dart';
import 'package:dartxero/Maps/MapFloat.dart';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/TraeInfoXcpModel.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void vDatosUsuario(BuildContext context, int Estatus) {
  showDialog(
      context: context,
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
              child: FormDatosUsuario(
                Estatus: Estatus,
              ),
            ),
          ],
        ));
      });
}

class FormDatosUsuario extends StatefulWidget {
  final int Estatus;

  const FormDatosUsuario({Key key, this.Estatus}) : super(key: key);
  @override
  _FormDatosUsuarioState createState() => _FormDatosUsuarioState();
}

class _FormDatosUsuarioState extends State<FormDatosUsuario> {
  // final TipoAccion; // 1 Crear, 2 Modificar
  final _formKey = GlobalKey<FormState>();
  String sValida = '';
  List<String> ChkDiasLaborales;
  List<String> ChkTipoServicio;
  String Hor1;
  String Hor2;
  String sFoto;
  LatLng Ubica;
  String _date = sFechaNac;
  TraeInfoXcpModel traeInfoCP;
  bool _TieneUbicacion;
  double _Latitud;
  double _Longitud;
  //bool bModifica;
  //ValCampoRestaurante ValidaRest;

  _sValida(String Tabla, String Campo, String Value) async {
    final result = await ValidaCampo(Tabla, Campo, Value);
    setState(() {
      sValida = result;
    });
  }

  Future<void> fn_TraeDatosXcp(String sCP) async {
    //final response = await http.get("${sURL}Login/TraeInfoXCP/${sCP}",);
    final response = await http.get(
      CadenaConexion("Login/TraeInfoXCP/${sCP}"),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.body != '[]') {
        var jSon = json.decode(response.body);
        traeInfoCP = TraeInfoXcpModel.fromJson(jSon[0]);
        setState(() {
          ctrl.txtColonia.text = traeInfoCP.Nombre_Colonia;
          ctrl.txtCiudad.text = traeInfoCP.Nombre_municipio;
        });
      } else {
        traeInfoCP = null;
        ctrl.txtColonia.text = '';
        ctrl.txtCiudad.text = '';
      }
    } else {
      traeInfoCP = null;
      ctrl.txtColonia.text = '';
      ctrl.txtCiudad.text = '';
    }
  }

  @override
  void initState() {
    //ValidaRest = ValCampoRestaurante();
    ValidaUser.IniciaCampos();
    bModifica = false;
    sFoto = '';
    Ubica = null;
    _TieneUbicacion = false;

    ctrl.txtName.text = "";
    ctrl.txtApellido.text = "";
    ctrl.txtNumCel.text = "";
    ctrl.txtFechaNac.text = "";
    ctrl.txtTipoPreferencia.text = '';
    ctrl.txtCalle.text = "";
    ctrl.txtCP.text = "";
    ctrl.txtColonia.text = "";
    ctrl.txtnumExt.text = "";
    ctrl.txtnumInt.text = "";
    ctrl.txtCiudad.text = "";

    if (widget.Estatus == 2) {
      ctrl.txtName.text = user.Nombre;
      ctrl.txtApellido.text = user.Apellido;
      ctrl.txtNumCel.text = user.NumCel;
      ctrl.txtFechaNac.text = user.FechaNac.toString();
      ctrl.txtTipoPreferencia.text = user.TipoPreferencia.toString();
      ctrl.txtCalle.text = user.Calle;
      ctrl.txtCP.text = user.cp;
      ctrl.txtColonia.text = user.Colonia;
      ctrl.txtnumExt.text = user.numExt.toString();
      ctrl.txtnumInt.text = user.numInt.toString();
      ctrl.txtCiudad.text = user.Ciudad;
      ctrl.txtReferenciaEnvio.text = user.Referencia;

      ctrl.NoCel.text = ctrl.txtNumCel.text;

      sFoto = user.foto == null ? '' : user.foto;

      dLatitud = user.Latitud;
      dLongitud = user.Longitud;
    }
    /*if (Restaurant.Latitud != null && Restaurant.Latitud != null){
        Ubica = LatLng(Restaurant.Latitud, Restaurant.Longitud);
      }else{
        Ubica = null;
      }
      */
  }

  void onPressConfirma() async {
    print('Entrar');

    if (_formKey.currentState.validate()) {
      print('Pasa validacion');
      //postUsuario(context);

    } else {
      print('Validacion');
      print(_formKey.toString());
    }
  }

  var SizedTipoAccion = {
    1: SizedBox(
      width: 50,
    ),
    2: SizedBox(
      width: 40,
    ),
  };

  void vMapFloatlcl(BuildContext context) {
    showDialog(
        context: context,
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
                //width: double.maxFinite,
                height: 430,
                child: Column(
                  children: [
                    MapFloat(),
                    Flexible(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    MaterialButton(
                        color: ColorApp,
                        textColor: ColorFondoApp,
                        child: Text(
                          sConfirma,
                          style: EstiloLetraBtn,
                        ),
                        onPressed: () {
                          setState(() {
                            _TieneUbicacion = UbicacionUsuario != null;
                            if (_TieneUbicacion) {
                              ctrl.txtCalle.text = UbicacionUsuario.Ubicacion;
                              ctrl.txtCP.text = UbicacionUsuario.UbicacionCP;
                              ctrl.txtColonia.text = UbicacionUsuario.Colonia;
                              dLatitud = UbicacionUsuario.Latitud;
                              dLongitud = UbicacionUsuario.Longitud;
                            }
                          });
                          Navigator.of(context).pop();
                          //Navigator.pop(context);
                        })
                  ],
                ),
              ),
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: _setImageView(),
                  decoration: esMarcoFotos,
                  alignment: Alignment.bottomCenter,
                  height: 160,
                  width: 200,
                ),
                Container(
                  //padding: EdgeInsets.only(top: 200),
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: ColorBtnTxt,
                    ),
                    color: ColorBoton,
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    splashColor: splashBtn,
                    disabledColor: disabledBth,
                    onPressed: () {
                      _showSelectionDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Fechas(),
            padding: EdgeInsets.only(top: 15.0),
          ),
          Container(
            child: TextFormField(
                decoration: InpDecoTxt(sNombre),
                style: EstiloLetraLB,
                controller: ctrl.txtName,
                onChanged: (value) {
                  if (widget.Estatus == 2) {
                    setState(() {
                      ValidaUser.Nombre = (value != ValidaUser.Nombre);
                      bModifica = ModificaCampos(3);
                    });
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sNombre);
                  }
                  return null;
                }),
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: TextFormField(
                decoration: InpDecoTxt(sApellido),
                style: EstiloLetraLB,
                controller: ctrl.txtApellido,
                onChanged: (value) {
                  if (widget.Estatus == 2) {
                    setState(() {
                      ValidaUser.Apellido = (value != ValidaUser.Apellido);
                      bModifica = ModificaCampos(3);
                    });
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sApellido);
                  }
                  return null;
                }),
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: TextFormField(
                decoration: InputDecoration(hintText: sCelular),
                keyboardType: TextInputType.phone,
                style: EstiloLetraLB,
                controller: ctrl.NoCel,
                onChanged: (value) {
                  if (widget.Estatus == 2) {
                    setState(() {
                      ValidaUser.NumCel = (value != ValidaUser.NumCel);
                      bModifica = ModificaCampos(3);
                    });
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sCelular);
                  } else {
                    _sValida('Usuario', 'NumCel', value);
                    if (sValida != 'OK' && sValida != '') {
                      return sValida;
                    }
                  }
                  return null;
                }),
            padding: EdgeInsets.only(top: 10.0),
          ),
          Row(
            children: [
              Expanded(
                //width: 300,
                child: Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: sDomicilio),
                    style: EstiloLetraLB,
                    controller: ctrl.txtCalle,
                    onChanged: (value) {
                      if (widget.Estatus == 2) {
                        setState(() {
                          ValidaUser.Calle = (value != ValidaUser.Calle);
                          bModifica = ModificaCampos(3);
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 30,
                child: MaterialButton(
                  color: ColorApp,
                  textColor: ColorLabel,
                  child: iUbicaSys,
                  padding: EdgeInsets.all(0),
                  shape: CircleBorder(),
                  onPressed: () {
                    setState(() {
                      vMapFloatlcl(context);
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            child: TextFormField(
                decoration: InpDecoTxt(sCP),
                style: EstiloLetraLB,
                controller: ctrl.txtCP,
                onChanged: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sCP);
                  } else {
                    //fn_TraeDatosXcp(value);
                    if (traeInfoCP != null) {
                      //ctrl.txtColonia.text = traeInfoCP.Nombre_Colonia;
                      //ctrl.txtCiudad.text = traeInfoCP.Nombre_municipio;
                    }
                  }
                  if (widget.Estatus == 2) {
                    setState(() {
                      ValidaUser.cp = (value != ValidaUser.cp);
                      bModifica = ModificaCampos(3);
                    });
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sCP);
                  }
                  return null;
                }),
            padding: EdgeInsets.only(top: 10.0),
          ),
          /*sLabelGen(
            nIndex: 2,
            sTitulo: sCP,
            txtController: ctrl.txtCP,
          ),*/
          /*TextFormField(
            decoration: InputDecoration(labelText: sCalle),
            style: EstiloLetraLB,
            controller: ctrl.txtCalle,
            onChanged: (value) {
              if (widget.Estatus == 2) {
                setState(() {
                  ValidaUser.Calle = (value != ValidaUser.Calle);
                  bModifica = ModificaCampos(3);
                });
              }
            },
          ),*/
          TextFormField(
            decoration: InputDecoration(labelText: sColonia),
            style: EstiloLetraLB,
            controller: ctrl.txtColonia,
            onChanged: (value) {
              if (widget.Estatus == 2) {
                setState(() {
                  ValidaUser.Colonia = (value != ValidaUser.Colonia);
                  bModifica = ModificaCampos(3);
                });
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: sReferencia),
            style: EstiloLetraLB,
            controller: ctrl.txtReferenciaEnvio,
            onChanged: (value) {
              if (widget.Estatus == 2) {
                setState(() {
                  ValidaUser.Colonia = (value != ValidaUser.Colonia);
                  bModifica = ModificaCampos(3);
                });
              }
            },
          ),
          /*TextFormField(
            decoration: InputDecoration(labelText: sCiudad),
            style: EstiloLetraLB,
            controller: ctrl.txtCiudad,
            onChanged: (value){
              if (widget.Estatus == 2) {
                setState(() {
                  ValidaUser.Ciudad = (value != ValidaUser.Ciudad);
                  bModifica = ModificaCampos(3);
                });
              }
            },
          ),*/
          TextFormField(
            decoration: InputDecoration(labelText: sNumInt),
            style: EstiloLetraLB,
            controller: ctrl.txtnumInt,
            onChanged: (value) {
              if (widget.Estatus == 2) {
                setState(() {
                  ValidaUser.numInt = (value != ValidaUser.numInt);
                  bModifica = ModificaCampos(3);
                });
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: sNumExt),
            style: EstiloLetraLB,
            controller: ctrl.txtnumExt,
            onChanged: (value) {
              if (widget.Estatus == 2) {
                setState(() {
                  ValidaUser.numExt = (value != ValidaUser.numExt);
                  bModifica = ModificaCampos(3);
                });
              }
            },
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10),
            height: 50.0,
            //padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
            child: RaisedButton(
              child: Text(
                widget.Estatus == 1 ? sConfirma : sGuardar,
                style: EstiloLetraBtn,
              ),
              color: ColorBoton,
              //padding: EdgeInsets.only(left: 130.0, right: 130.0),
              //padding: EdgeInsets.all(50.0),
              splashColor: splashBtn,
              disabledColor: disabledBth,
              onPressed:
                  (widget.Estatus == 2 && bModifica) ? () => onPressed() : null,
              /*onPressed: () async {
                  print('Entrar');
                  if (_formKey.currentState.validate()) {
                    //postUsuario(context);
                    /*final UserModel NewUsuario = await createUser();
                    print(NewUsuario.toString());
                    setState(() {
                      user = NewUsuario;
                      dUsuarioGLB = NewUsuario;
                    });*/
                    if (widget.Estatus == 2) {
                      print('Entro a Update');
                      final UserModel UpdateUser = await UpdateUsuario();
                      setState(() {
                        user = UpdateUser;
                        Navigator.pop(context);
                      });
                    }
                    /*
                    if (user != null) {
                      //postUsuario(context, user.Nickname);
                      Navigator.pushReplacementNamed(context, '/BandejaUs');
                    }*/
                  } else {
                    print(_formKey.toString());
                  }
                }*/
            ),
          ),
        ],
      ),
    );
  }

  void onPressed() async {
    if (_formKey.currentState.validate()) {
      if (widget.Estatus == 2) {
        final UserModel UpdateUser = await UpdateUsuario();
        setState(() {
          user = UpdateUser;
          Navigator.pop(context);
        });
      }
    } else {
      print(_formKey.toString());
    }
  }

  Future<UserModel> createEmpresa() async {
    String img64 = '';
    if (imageFile != null) img64 = base64Encode(imageFile.readAsBytesSync());
    //final response = await http.post('${sURL}Login/AddRestaurant', body: {
    final response =
        await http.post(CadenaConexion('Login/AddRestaurant'), body: {
      'Nickname': ctrl.txtNewUser.text,
      'NumCel': ctrl.txtNumCel.text,
      'Pass': ctrl.txtNewPass.text,
      'ActivoUs': 'ACTIVO',
      'TipoUsuario': "2",
      'NombreUs': ctrl.txtName.text,
      'ApellidoUs': ctrl.txtApellido.text,
      'FechaRegUs': DateTime.now().toIso8601String(),
      //                                      Restaurant
      'Nombre': ctrl.txtNombreEmp.text,
      'Descripcion': ctrl.txtDescripcionEmp.text,
      'TipoCategoria': ctrl.txtTipoCategoriaEmp.text,
      //'TipoRestaurant': ctrl.txtTipoRestaurantEmp.text,
      'Telefono': ctrl.NoCelEmp.text,
      'Domicilio': ctrl.txtDomicilioEmp.text,
      'Sector': "0", //ctrl.txtSectorEmp.text,
      'DiasLaborales': ctrl.txtDiasLaboralesEmp.text,
      'TipoServ': ctrl.txtTipoServEmp.text,
      'horario': ctrl.txtHorarioEmp.text,
      'Activo': 'ACTIVO',
      'logo': img64,
      'FechaReg': DateTime.now().toIso8601String(),
      'Latitud': dLatitud.toString(),
      'Longitud': dLongitud.toString()
    });
    print("Estatus: ${response.statusCode}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jSon = json.decode(response.body);
      return UserModel.fromJson(jSon[0]);
    } else {
      return null;
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(sSelecImgQuest),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      child: Text(sGaleria),
                      onTap: () {
                        _openImg(context, ImageSource.gallery);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      child: Text(sCamara),
                      onTap: () {
                        _openImg(context, ImageSource.camera);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openImg(BuildContext context, ImageSource Source) async {
    //File picture = await ImagePicker.pickImage(source: Source);
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    File picture = File(pickedFile.path);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: picture.path,
        maxHeight: 720,
        maxWidth: 720,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: ColorApp,
            toolbarWidgetColor: ColorFondoApp,
            cropGridColor: ColorBoton,
            showCropGrid: false,
            backgroundColor: ColorBoton,
            //initAspectRatio: CropAspectRatioPreset.ratio5x4,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
          resetAspectRatioEnabled: false,
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
        ValidaRest.logo = true;
        bModifica = ModificaCampos(1);
      });
    }
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null && ValidaUser.foto) {
      return Image.file(
        imageFile,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (sFoto == null || sFoto == '') {
      return Center(
          child: Text(
        sSelecImg,
        style: EstiloLetraLB,
      ));
    } else {
      print(sFoto);
      return Imagen(sFoto);
    }
  }

  Image Imagen(String BASE64_STRING) {
    Uint8List bytes = base64Decode(BASE64_STRING);
    print(BASE64_STRING);
    return Image(
      image: MemoryImage(bytes),
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  Container Fechas() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showDatePicker(context,
              theme: DatePickerTheme(
                containerHeight: 150.0,
              ),
              showTitleActions: true,
              minTime: DateTime(1950, 01, 01),
              maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
            print('confirm $date');
            //_date = '${date.year} - ${date.month} - ${date.day}';
            _date = '${date.day} / ${sRegresaMes(date.month)} / ${date.year}';
            sFechaNacCont = DateTime(date.year, date.month, date.day);
            setState(() {});
          },
              currentTime:
                  sFechaNacCont == null ? DateTime.now() : sFechaNacCont,
              locale: ConfLocal);
        },
        child: Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Container(
              child: Row(
                children: <Widget>[
                  iFechas,
                  Text(
                    " $_date",
                    style: estiloFechas,
                  ),
                ],
              ),
            )),
        color: ColorFondoApp,
      ),
    );
  }
}

class UbicaBtn extends StatelessWidget {
  final LatLng llTraeUbica;

  const UbicaBtn({key, this.llTraeUbica}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: iUbica,
        color: ColorBoton,
        splashColor: splashBtn,
        disabledColor: disabledBth,
        padding: llTraeUbica != null
            ? EdgeInsets.only(left: 130.0, right: 130.0)
            : EdgeInsets.only(left: 165.0, right: 165.0),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  content: SingleChildScrollView(
                      child: ListBody(
                    children: [
                      Container(
                        child: MapSample(
                          llTraeUbica: llTraeUbica,
                        ),
                        height: 300,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Text(msjAceptar),
                        onTap: () {
                          if (ValidaRest != null) {
                            bModifica = ModificaCampos(1);
                          }
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )),
                );
              });
        });
  }
}

Future<UserModel> UpdateUsuario() async {
  String img64 = '';
  if (imageFile != null) img64 = base64Encode(imageFile.readAsBytesSync());
  //final response = await http.post('${sURL}Usuario/UpdateUsuario',
  final response =
      await http.post(CadenaConexion('Usuario/UpdateUsuario'), body: {
    'id': user.id.toString(),
    'Nickname': user.Nickname,
    'NumCel': ctrl.txtNumCel.text,
    'Pass': user.Pass,
    'Activo': 'ACTIVO',
    'LoginFacebook': bLoguinFacebook.toString(),
    'Nombre': ctrl.txtName.text,
    'Apellido': ctrl.txtApellido.text,
    'FechaNac': (sFechaNacCont != null)
        ? sFechaNacCont.toIso8601String()
        : user.FechaNac.toString(),
    'FechaReg': user.FechaReg.toString(),
    'TipoPreferencia': ctrl.txtTipoPreferencia.text,
    'Calle': ctrl.txtCalle.text,
    'cp': ctrl.txtCP.text,
    'Colonia': ctrl.txtColonia.text,
    'numExt': ctrl.txtnumExt.text,
    'numInt': ctrl.txtnumInt.text,
    'Ciudad': ctrl.txtCiudad.text,
    'foto': img64, //sImagen(imageFile),
    'Latitud': dLatitud.toString(),
    'Longitud': dLongitud.toString(),
    'Referencia': ctrl.txtReferenciaEnvio.text,
  });
  print("Estatus: ${response.statusCode}");
  if (response.statusCode == 201 || response.statusCode == 200) {
    var jSon = json.decode(response.body);
    return UserModel.fromJson(jSon[0]);
  } else {
    return null;
  }
}
