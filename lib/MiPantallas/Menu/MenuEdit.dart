import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartxero/MiFramework/Base/BaseSubCategoria.dart';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart';
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/ImagenModel.dart';
import 'package:dartxero/MiModel/MenuModel.dart';
import 'package:dartxero/MiModel/SubCategoriaModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MenuEdit extends StatefulWidget {
  final MenuModel Data;
  const MenuEdit({Key key, this.Data}) : super(key: key);
  @override
  _MenuEditState createState() => _MenuEditState(Data);
}

class _MenuEditState extends State<MenuEdit> {
  final MenuModel Data;

  final _formKey = GlobalKey<FormState>();
  _MenuEditState(this.Data);

  String sValida = '';

  _sValida(String Tabla, String Campo, String Value) async {
    final result = await ValidaCampo(Tabla, Campo, Value);
    sValida = result;
  }

  ImageProvider ImagenMenu(int id_menu)  {
    ImageMenuStr(id_menu);
    Uint8List bytes = base64Decode(BASE64_STRING != null? BASE64_STRING : SinImagen);
    return MemoryImage(bytes);
  }

  Future<String> ImageMenuStr(int id_menu) async {
    //final response = await http.get('${sURL}Menu/ViewPlatillosImagen/${id_menu}',);
    final response = await http.get(CadenaConexion('Menu/ViewPlatillosImagen/${id_menu}'),);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var Json = json.decode(response.body);
      ImagenModel Imagen = ImagenModel.fromJson(Json[0]);
      setState(() {
        BASE64_STRING = Imagen.foto != Null ? Imagen.foto : SinImagen;
        //BASE64_STRING = Imagen.foto;
      });
    }else
      BASE64_STRING = SinImagen;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      BASE64_STRING = '';
      imageFile = null;
      ImagenMenu(Data.id_menu);

      bModifica = false;
      txtPlaNombre.text = "";
      txtPlaDescripcion.text = "";
      txtPlaTipoCategoria.text = "";
      txtPlaSubCategoria.text = "";
      txtPlaPrecio.text = "";
      txtPlaExtras.text = "";
      MaskPrecioPlo.text = "0.00";

      if (Data != null) {
        ValidaMenu.IniciaCampos();
        txtPlaNombre.text = Data.Nombre;
        txtPlaDescripcion.text = Data.Descripcion;
        txtPlaTipoCategoria.text =
        (Data.TipoCategoria != null) ? Data.TipoCategoria.toString() : "";
        txtPlaSubCategoria.text = (Data.TipoCategoria != null) ? Data.TipoCategoria.toString() :  "";
        txtPlaPrecio.text = (Data.Precio != null) ? Data.Precio.toString() : "";
        txtPlaExtras.text = (Data.Extras != null) ? Data.Extras : "";
        MaskPrecioPlo.text =
        (Data.Precio != null) ? Data.Precio.toString() + '0' : "0.00";
      }

      CargaItem(0, Restaurant.TipoCategoria,txtPlaSubCategoria.text != ''? int.parse(txtPlaSubCategoria.text):null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          //PhotoPreviewScreen(sTraeImagen: Data.foto,),
          Container(
              child: Column(
                children: <Widget>[
                  Container(child: _setImageView(),
                    decoration: esMarcoFotos,
                    alignment: Alignment.bottomCenter,
                    //padding: EdgeInsets.only(top: 200),
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
                      //padding: EdgeInsets.all(50.0),
                      splashColor: splashBtn,
                      disabledColor: disabledBth,
                      onPressed: () {
                        _showSelectionDialog(context);
                      },
                    ),
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              decoration: InpDecoTxt(sNombre),
              style: EstiloLetraLB,
              autofocus: true,
              controller: txtPlaNombre,
              onChanged:(Value) {
                setState(() {
                  ValidaMenu.Nombre = Value != Data.Nombre;
                  bModifica = ModificaCampos(2);
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return sMensajeErrorComp(sNombre);
                } else if (value != Data.Nombre) {
                  _sValida('menu', 'Nombre', value);
                  if (sValida != 'OK' && sValida != '') {
                    return sValida;
                  }
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              maxLines: 2,
              decoration: InpDecoTxt(sDescripcion,),
              style: EstiloLetraLB,
              controller: txtPlaDescripcion,
              onChanged:(Value) {
                setState(() {
                  ValidaMenu.Descripcion = Value != Data.Descripcion;
                  bModifica = ModificaCampos(2);
                });
              },
              validator: (value) {
               /* if (value.isEmpty) {
                  return sMensajeErrorComp(sDescripcion);
                }*/
                return null;
              },
            ),
          ),
          //Container(child: BaseSubCategoria(VerTodos: 0,Categoria: Restaurant.TipoCategoria,Seleccionada: txtPlaSubCategoria.text != ''? int.parse(txtPlaSubCategoria.text):null,menu: Data,),),
          Container(child: DropdownButton<ListItem>(
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
                  txtPlaSubCategoria.text = _selectedItem.value.toString();
                  if (ValidaMenu != null) {
                    ValidaMenu.TipoCategoria = (value.value != Data.TipoCategoria);
                    bModifica = ModificaCampos(2);
                  }
                });
              }),),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              decoration: InpDecoTxt(sPrecio),
              style: EstiloLetraLB,
              controller: MaskPrecioPlo,
              keyboardType: TextInputType.number,
              onChanged:(Value) {
                setState(() {
                  ValidaMenu.Precio = Value.replaceAll('\$', '') != Data.Precio.toString();
                  bModifica = ModificaCampos(2);
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return sMensajeErrorComp(sPrecio);
                } else if (double.parse(value.replaceAll('\$', '')) <= 0) {
                  return "Precio debe de ser mayor a 0";
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextFormField(
              decoration: InpDecoTxt("Extras",),
              style: EstiloLetraLB,
              controller: txtPlaExtras,
              onChanged:(Value) {
                setState(() {
                  ValidaMenu.Extras = Value != Data.Extras;
                  bModifica = ModificaCampos(2);
                });
              },
              /*validator: (value) {
                if (value.isEmpty) {
                  return sMensajeErrorComp("Extras");
                }
                return null;
              },*/
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: RaisedButton(
              child: Text( Data == null ? msjAceptar : sGuardar,
                style: EstiloLetraBtn,
              ),
              color: ColorBoton,
              splashColor: splashBtn,
              disabledColor: disabledBth,
              onPressed: bModifica == false ? null : () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (Data != null) {
                    setState(() {
                      PlatilloEdit(Data.id_menu, Data.id_restaurant);
                      //FillMenu(Data);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/BandejaRest');
                    });
                  }
                } else {
                  print(_formKey.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  List<ListItem> _SubCategoria = [];

  Future<void> CargaItem(int VerTodos, int Categoria, int Seleccionada) async {
    List<SubCategoriaModel> lista = await SubCategoriaView(VerTodos,Categoria);
    _SubCategoria.clear();
    lista.forEach((element) {
      _SubCategoria.add(ListItem(element.id_SubCategoria, element.SubCatNombre));
    });
    setState(() {
      ComboBoxLocal(Seleccionada);
    });
  }

  DropdownButton<ListItem> ComboBoxLocal(int Seleccionada){
    _dropdownMenuItems = buildDropDownMenuItems(_SubCategoria);

    if (Seleccionada != null) {
      for (int i = 0; i <= _dropdownMenuItems.length - 1; i++)
        if (_dropdownMenuItems[i].value.value == Seleccionada) {
          _selectedItem = _dropdownMenuItems[i].value;
        }
    } else {
      _selectedItem = _dropdownMenuItems[0].value;
    }
  }

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

  void FillMenu(MenuModel Menu){
    txtPlaNombre.text = Menu.Nombre;
    txtPlaDescripcion.text = Menu.Descripcion;
    txtPlaTipoCategoria.text =
    (Menu.TipoCategoria != null) ? Menu.TipoCategoria.toString() : "";
    txtPlaPrecio.text = (Menu.Precio != null) ? Menu.Precio.toString() : "";
    txtPlaExtras.text = (Menu.Extras != null) ? Menu.Extras : "";
    MaskPrecioPlo.text =
    (Menu.Precio != null) ? Menu.Precio.toString() + '0' : "0.00";
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
                    SizedBox(height: 15,),
                    GestureDetector(
                      child: Text(sGaleria),
                      onTap: () {
                        _openImg(context, ImageSource.gallery);
                      },
                    ),
                    SizedBox(height: 15,),
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
          ValidaMenu.foto = true;
          bModifica = ModificaCampos(2);
      });
    }
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile, width: 200, height: 200, fit: BoxFit.cover,);
    } else if (Data.foto == null) {
      return Center(child: Text(sSelecImg,style: EstiloLetraLB,));
    } else {

      return Imagen(BASE64_STRING);
    }
  }

  Image Imagen (String BASE64_STRING){
    Uint8List bytes = base64Decode(BASE64_STRING);
    print(BASE64_STRING);
    return Image(image: MemoryImage(bytes), width: 200, height: 200, fit: BoxFit.cover,);
  }

  Future<void> PlatilloEdit(int id_menu, int id_restaurant) async {
    Menu = await PlatilloEditApi(id_menu, id_restaurant);
  }

  Future<MenuModel> PlatilloEditApi(int id_Menu, int id_Restaurante) async {
    String img64 = '';
    if (imageFile != null)
      img64 = base64Encode(imageFile.readAsBytesSync());
    //final response = await http.post('${sURL}Menu/EditPlatillo', body: {
    final response = await http.post(CadenaConexion('Menu/EditPlatillo'), body: {
      'id_menu': id_Menu.toString(),
      'id_restaurant': id_Restaurante.toString(),
      'Nombre': txtPlaNombre.text,
      'Descripcion': txtPlaDescripcion.text,
      'TipoCategoria': txtPlaSubCategoria.text,
      'Precio': MaskPrecioPlo.text.replaceAll('\$', ''),
      'Extras': txtPlaExtras.text,
      'foto': ValidaMenu.foto ? img64 : Data.foto,
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jSon = json.decode(response.body);
      print(img64);
      return MenuModel.fromJson(jSon[0]);
    } else {
      return null;
    }
  }

}



