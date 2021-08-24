import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartxero/Maps/Map.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiAccionesEmpresa.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiFramework.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiFramework/miRestaurant.dart';
import 'package:dartxero/MiModel/RestaurantModel.dart';
import 'package:dartxero/MiUtilidad/MiPhoto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dartxero/MiModel/UsuarioModel.dart';

class DatosRestaurante extends StatefulWidget {
  @override
  _DatosRestauranteState createState() => _DatosRestauranteState();
}

class _DatosRestauranteState extends State<DatosRestaurante> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          PhotoPreviewScreen(
            sTraeImagen: '',
          ),
        ],
        shrinkWrap: true,
      ),
    );
  }
}

void vDatosRestaurente(BuildContext context) {
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
              child: FormDatosRestaurant(
                TipoAccion: 2,
              ),
            ),
          ],
        ));
      });
}

class FormDatosRestaurant extends StatefulWidget {
  final TipoAccion;

  const FormDatosRestaurant({key, this.TipoAccion}) : super(key: key);
  @override
  _FormDatosRestaurantState createState() =>
      _FormDatosRestaurantState(TipoAccion);
}

class _FormDatosRestaurantState extends State<FormDatosRestaurant> {
  final TipoAccion; // 1 Crear, 2 Modificar
  final _formKey = GlobalKey<FormState>();
  String sValida = '';
  List<String> ChkDiasLaborales;
  List<String> ChkTipoServicio;
  String Hor1;
  String Hor2;
  String sFoto;
  LatLng Ubica;
  //bool bModifica;
  //ValCampoRestaurante ValidaRest;

  _FormDatosRestaurantState(this.TipoAccion);

  _sValida(String Tabla, String Campo, String Value) async {
    final result = await ValidaCampo(Tabla, Campo, Value);
    setState(() {
      sValida = result;
    });
  }

  @override
  void initState() {
    //ValidaRest = ValCampoRestaurante();
    ValidaRest.IniciaCampos();
    bModifica = false;
    ctrl.txtTipoCategoriaEmp.text = '';
    Hor1 = '';
    Hor2 = '';
    sFoto = '';
    Ubica = null;
    if (TipoAccion == 1) {
      ctrl.txtNombreEmp.text = '';
      ctrl.txtDescripcionEmp.text = '';
      ctrl.txtTelefonoEmp.text = '';
      ctrl.NoCelEmp.text = ctrl.NoCel.text;
      ctrl.txtDomicilioEmp.text = '';
      ctrl.txtTipoCategoriaEmp.text = '1';
      ctrl.txtTipoRestaurantEmp.text = '0';
      ctrl.txtSectorEmp.text = '';
      ctrl.txtDiasLaboralesEmp.text = '';
      ctrl.txtTipoServEmp.text = '';
      ctrl.txtHorarioEmp.text = '';
      Hor1 = 'AM';
      Hor2 = 'PM';
      sEntradaAMPM = 'AM';
      sSalidaAMPM = 'PM';
      //imageFile = null;
    } else if (TipoAccion == 2) {
      imageFile = null;
      ChkDiasLaborales =
          (((Restaurant.DiasLaborales.replaceAll('[', '')).replaceAll(']', ''))
                  .replaceAll(' ', ''))
              .split(',');
      ChkTipoServicio = List<String>();
      var test = (Restaurant.TipoServ != null)
          ? ((Restaurant.TipoServ.replaceAll('[', '')).replaceAll(']', ''))
              .split(',')
          : [];
      for (int i = 0; i <= test.length - 1; i++)
        ChkTipoServicio.add(test[i].toString().trimLeft());

      ctrl.txtNombreEmp.text = Restaurant.Nombre;
      ctrl.txtDescripcionEmp.text = Restaurant.Descripcion;
      ctrl.txtTelefonoEmp.text = Restaurant.Telefono;
      ctrl.NoCelEmp.text = Restaurant.Telefono;
      ctrl.txtDomicilioEmp.text = Restaurant.Domicilio;
      ctrl.txtTipoCategoriaEmp.text = Restaurant.TipoCategoria.toString();
      ctrl.txtTipoRestaurantEmp.text = Restaurant.TipoRestaurant.toString();
      ctrl.txtSectorEmp.text = Restaurant.Sector.toString();
      ctrl.txtDiasLaboralesEmp.text = Restaurant.DiasLaborales;
      ctrl.txtTipoServEmp.text = Restaurant.TipoServ;
      ctrl.txtHorarioEmp.text = Restaurant.horario;

      List<String> sHorario = Restaurant.horario.split(' ');
      ctrl.horaEnt.text = sHorario[0];
      ctrl.horaSal.text = sHorario[3];
      ctrl.txtAM.text = sHorario[1];
      ctrl.txtPM.text = sHorario[4];
      Hor1 = sHorario[1];
      Hor2 = sHorario[4];
      sEntradaAMPM = sHorario[1];
      sSalidaAMPM = sHorario[4];
      //04:00 PM A 12:00 AM
      sFoto = Restaurant.logo == null ? '' : Restaurant.logo;
      if (Restaurant.Latitud != null && Restaurant.Latitud != null) {
        Ubica = LatLng(Restaurant.Latitud, Restaurant.Longitud);
      } else {
        Ubica = null;
      }
    }
  }

  void onPressConfirma() async {
    print('Entrar');
    ctrl.txtNumCel.text = ctrl.NoCelEmp.text;
    ctrl.txtHorarioEmp.text =
        "${ctrl.txtHoraEnt.text} ${sEntradaAMPM} A ${ctrl.txtHoraSal.text} ${sSalidaAMPM}";

    if (_formKey.currentState.validate()) {
      print('Pasa validacion');
      //postUsuario(context);
      if (TipoAccion == 1) {
        final UserModel NewUsuario = await createEmpresa();
        print(NewUsuario.toString());
        setState(() {
          user = NewUsuario;
        });
        if (user != null) {
          postRestaurant(context, user.Nombre);
          Restaurant = await RestaurantView(user.id);
          Navigator.pushReplacementNamed(context, '/BandejaRest');
        }
      } else if (TipoAccion == 2) {
        print('Entro a Update');
        final RestaurantModel UpdateRest = await UpdateRestaurante();
        setState(() {
          Restaurant = UpdateRest;
          Navigator.pop(context);
        });
      }
    } else {
      print('Validacion');
      print(_formKey.toString());
    }
  }

  //                  0
  List<ListItem> _TipoCategoria = [
    ListItem("1", "Desayunos"),
    ListItem("2", "Comidas Corridas"),
    ListItem("3", "Bebidas"),
    ListItem("4", "Mariscos"),
    ListItem("5", "Comida Rapida"),
    ListItem("6", "Postres"),
    ListItem("7", "Comida China"),
    ListItem("8", "Comida Japonesa"),
    ListItem("9", "Saludable")
  ];
  //                1 y 2
  List<ListItem> _Horario = [ListItem("AM", "AM"), ListItem("PM", "PM")];
  //                3
  List<ListItem> _TipoServicio = [
    ListItem("dom", "Domicilio"),
    ListItem("lle", "Ordenar para llevar")
  ];
  //                1
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: sTituloschico(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  DropdownButton<ListItem> ComboBoxLocal(
      int nTipo, String Selec, int nTipoAccion) {
    switch (nTipo) {
      case 0:
        _dropdownMenuItems = buildDropDownMenuItems(_TipoCategoria);
        break;
      case 1:
        _dropdownMenuItems = buildDropDownMenuItems(_Horario);
        break;
      case 2:
        _dropdownMenuItems = buildDropDownMenuItems(_Horario);
        break;
    }
    if (Selec == '') {
      _selectedItem = _dropdownMenuItems[0].value;
    } else {
      for (int i = 0; i <= _dropdownMenuItems.length - 1; i++)
        if (_dropdownMenuItems[i].value.value == Selec) {
          _selectedItem = _dropdownMenuItems[i].value;
        }
    }
    return DropdownButton<ListItem>(
        style: EstiloLetraLB,
        underline: Container(
          height: 0,
          color: ColorApp,
        ),
        value: _selectedItem,
        items: _dropdownMenuItems,
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
            switch (nTipo) {
              case 0:
                ctrl.txtTipoCategoriaEmp.text = _selectedItem.value;
                if (nTipoAccion == 2) {
                  ValidaRest.TipoCategoria = ctrl.txtTipoCategoriaEmp.text !=
                      Restaurant.TipoCategoria.toString();
                  bModifica = ModificaCampos(1);
                }
                break;
              case 1:
                sEntradaAMPM = _selectedItem.value;
                if (nTipoAccion == 2) {
                  Hor1 = sEntradaAMPM;
                  ValidaRest.AM = sEntradaAMPM != ctrl.txtAM.text;
                  bModifica = ModificaCampos(1);
                } else if (nTipoAccion == 1) {
                  Hor1 = sEntradaAMPM;
                }

                break;
              case 2:
                sSalidaAMPM = _selectedItem.value;
                if (nTipoAccion == 2) {
                  Hor2 = sSalidaAMPM;
                  ValidaRest.PM = sSalidaAMPM != ctrl.txtPM.text;
                  bModifica = ModificaCampos(1);
                } else if (nTipoAccion == 1) {
                  Hor2 = sSalidaAMPM;
                }
                break;
            }
          });
        });
  }

  var SizedTipoAccion = {
    1: SizedBox(
      width: 50,
    ),
    2: SizedBox(
      width: 40,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            child: Container(
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
            )),
            //PhotoPreviewScreen(sTraeImagen: sFoto),
          ),
          SizedBox(height: 20),
          Container(
            //height: 40,
            child: TextFormField(
                decoration: InpDecoTxt(sNomRestauran),
                style: EstiloLetraLB,
                controller: ctrl.txtNombreEmp,
                onChanged: (value) {
                  if (TipoAccion == 2) {
                    setState(() {
                      ValidaRest.Nombre = (value != Restaurant.Nombre);
                      bModifica = ModificaCampos(1);
                    });
                  } else {
                    _sValida('Restaurant', 'Nombre', value);
                    if (sValida != 'OK' && sValida != '') {
                      return sValida;
                    }
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sNomRestauran);
                  } else if (TipoAccion == 1) {
                    _sValida('Restaurant', 'Nombre', value);
                    if (sValida != 'OK' && sValida != '') {
                      return sValida;
                    }
                  }
                  return null;
                }),
          ),
          SizedBox(height: 10),
          Container(
            height: 80,
            child: TextFormField(
                maxLines: 2,
                decoration: InpDecoTxt(sDescripcion),
                style: EstiloLetraLB,
                controller: ctrl.txtDescripcionEmp,
                onChanged: (value) {
                  if (TipoAccion == 2) {
                    setState(() {
                      ValidaRest.Descripcion =
                          (value != Restaurant.Descripcion);
                      bModifica = ModificaCampos(1);
                    });
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return sMensajeErrorComp(sDescripcion);
                  }
                  return null;
                }),
          ),
          /*SizedBox(height: 10),
          Container(
            height: 80,
            child: TextFormField(
                maxLines: 2,
                decoration: InpDecoTxt(sDomicilio),
                style: EstiloLetraLB,
                controller: ctrl.txtDomicilioEmp,
                onChanged: (value) {
                  if (TipoAccion == 2) {
                    setState(() {
                      ValidaRest.Domicilio = (value != Restaurant.Domicilio);
                      bModifica = ModificaCampos(1);
                    });
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sDomicilio);
                  }
                  return null;
                }),
          ),*/
          SizedBox(height: 10),
          Container(
            child: TextFormField(
                decoration: InpDecoTxt(sTelefono),
                keyboardType: TextInputType.phone,
                style: EstiloLetraLB,
                controller: ctrl.NoCelEmp,
                //readOnly: true,
                enabled: false,
                onChanged: (value) {
                  if (TipoAccion == 2) {
                    setState(() {
                      ValidaRest.Telefono = (value != Restaurant.Telefono);
                      bModifica = ModificaCampos(1);
                    });
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return sMensajeErrorComp(sTelefono);
                  }
                  return null;
                }),
          ),
          MiDivisor(),
          //comboboxDos(nTipo: 0,Selec: ctrl.txtTipoCategoriaEmp.text,nTipoAccion: TipoAccion,),
          /*Row(
            children: [
              Text('Tipo Restaurante:',style: EstiloLetraLB,),
              //SizedBox(width: 50,),
              SizedTipoAccion[TipoAccion],
              ComboBoxLocal(0, ctrl.txtTipoCategoriaEmp.text, TipoAccion,),
            ],
          ),*/
          Text(
            'Tipo Restaurante:',
            style: EstiloLetraLB,
          ),
          SizedTipoAccion[TipoAccion],
          ComboBoxLocal(
            0,
            ctrl.txtTipoCategoriaEmp.text,
            TipoAccion,
          ),
          //ComboBoxLocal(0, ctrl.txtTipoCategoriaEmp.text, TipoAccion,),
          Container(
            child: Text(
              'Dias Laborales:',
              style: EstiloLetraLB,
            ),
            height: 30,
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            //height: 70,
            decoration: esMarcoBox,
            width: 70,
            //padding: EdgeInsets.only(top: 10),
            alignment: Alignment.topLeft,
            child: CheckboxGroup(
              labels: sDiasSemana,
              checked: ChkDiasLaborales,
              labelStyle: EstiloLetraLB,
              //disabled: ["Wednesday","Friday"],
              onChange: (isChecked, label, index) {},
              onSelected: (List<String> checked) {
                print("checked: ${checked.toString()}");
                setState(() {
                  ChkDiasLaborales = checked;
                  ctrl.txtDiasLaboralesEmp.text = checked.toString();
                  if (TipoAccion == 2) {
                    ValidaRest.DiasLaborales =
                        (ctrl.txtDiasLaboralesEmp.text.replaceAll(' ', '') !=
                            Restaurant.DiasLaborales);
                    bModifica = ModificaCampos(1);
                  }
                });
              },
            ),
          ),
          Container(
            child: Text(
              'Horario:',
              style: EstiloLetraLB,
            ),
            height: 30,
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            decoration: esMarcoBox,
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Center(child: sTituloschico('Apertura')),
                ),
                Container(
                  width: 45,
                  child: TextFormField(
                      decoration: InputDecoration(hintText: '00:00'),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15.0, color: ColorLabel),
                      controller: ctrl.horaEnt,
                      onChanged: (value) {
                        if (TipoAccion == 2) {
                          setState(() {
                            ValidaRest.horario1 = (value != Hor1);
                            bModifica = ModificaCampos(1);
                            if (ValidaRest.horario1) Hor1 = value;
                          });
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese Un Horario Inicio';
                        }
                        return null;
                      }),
                ),
                //Container(width: 47,child: comboboxDos(nTipo: 1,Selec: Hor1,nTipoAccion: TipoAccion,),),
                Container(
                  width: 47,
                  child: ComboBoxLocal(
                    1,
                    Hor1,
                    TipoAccion,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(child: sTituloschico('Salida')),
                ),
                Container(
                  width: 45,
                  child: TextFormField(
                      decoration: InputDecoration(hintText: '00:00'),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0, color: ColorLabel),
                      controller: ctrl.horaSal,
                      onChanged: (value) {
                        if (TipoAccion == 2) {
                          setState(() {
                            ValidaRest.horario2 = (value != Hor2);
                            bModifica = ModificaCampos(1);
                          });
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese Un Horario Cierre';
                        }
                        return null;
                      }),
                ),
                //Container(width: 47,child: comboboxDos(nTipo: 2,Selec: Hor2,nTipoAccion: TipoAccion,),),
                Container(
                  width: 47,
                  child: ComboBoxLocal(
                    2,
                    Hor2,
                    TipoAccion,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              'Tipo Servicio:',
              style: EstiloLetraLB,
            ),
            height: 30,
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            decoration: esMarcoBox,
            width: 70,
            alignment: Alignment.topLeft,
            child: CheckboxGroup(
                labels: sTipoOrden,
                checked: ChkTipoServicio,
                labelStyle: EstiloLetraLB,
                //checked: (TipoAccion == 1)? [] : (TipoAccion == 2) ? Restaurant.TipoServ:[],
                //disabled: ["Wednesday","Friday"],
                onChange: (bool isChecked, String label, int index) => print(
                    "isChecked: $isChecked   label: $label  index: $index"),
                onSelected: (List<String> checked) {
                  print("checked: ${checked.toString()}");
                  setState(() {
                    ChkTipoServicio = checked;
                    ctrl.txtTipoServEmp.text = checked.toString();
                    if (TipoAccion == 2) {
                      setState(() {
                        ValidaRest.TipoServ =
                            (ctrl.txtTipoServEmp.text != Restaurant.TipoServ);
                        bModifica = ModificaCampos(1);
                      });
                    }
                  });
                }),
          ),
          MiDivisor(),
          TipoAccion == 2
              ? Container(
                  child: MapWin(
                    llTraeUbica: Ubica,
                  ),
                  height: 200,
                  padding: EdgeInsets.only(top: 10),
                )
              : Container(),
          Container(
            //alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: TipoAccion == 2
                ? UbicaBtn(
                    llTraeUbica: Ubica,
                  )
                : UbicaBtn(
                    llTraeUbica: null,
                  ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                RaisedButton(
                  child: Text(
                    TipoAccion == 2 ? sGuardar : sConfirma,
                    style: EstiloLetraBtn,
                  ),
                  color: ColorBoton,
                  padding: TipoAccion == 1
                      ? EdgeInsets.only(left: 118.0, right: 116.0)
                      : EdgeInsets.only(left: 105.0, right: 105.0),
                  splashColor: splashBtn,
                  disabledColor: disabledBth,
                  //onPressed: TipoAccion == 1 ? () => onPressConfirma() : TipoAccion == 2 && bModifica ? () => onPressConfirma() : null ,
                  onPressed: (TipoAccion == 1) || (TipoAccion == 2 && bModifica)
                      ? () => onPressConfirma()
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postRestaurant(BuildContext context, String nick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            //title: Text("From where do you want to take the photo?"),
            content: SingleChildScrollView(
              child: Text(msjCreo(2, nick)),
            ),
          );
        });
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
      'Calle': ctrl.txtCalle.text,
      'cp': ctrl.txtCP.text,
      'Colonia': ctrl.txtColonia.text,
      'numExt': ctrl.txtnumExt.text,
      'numInt': ctrl.txtnumInt.text,
      'Ciudad': ctrl.txtCiudad.text,
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
      'Longitud': dLongitud.toString(),
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
    final pickedFile = await picker.getImage(source: Source);
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
    if (imageFile != null && ValidaRest.logo) {
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
            ? EdgeInsets.only(left: 118.0, right: 116.0)
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
