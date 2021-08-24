import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

MyPreferences _myPreferences = MyPreferences();

TextEditingController txtUser = new TextEditingController(
    text: _myPreferences.automatic == true ? _myPreferences.user : "");
TextEditingController txtPass = new TextEditingController(
    text: _myPreferences.automatic == true ? _myPreferences.password : "");

TextEditingController txtNewUser = new TextEditingController();
TextEditingController txtNewPass = new TextEditingController();
TextEditingController txtNewPassConf = new TextEditingController();

TextEditingController txtName = new TextEditingController();
TextEditingController txtApellido = new TextEditingController();
TextEditingController txtNumCel = new TextEditingController(text: NoCel.text);
TextEditingController txtFechaNac = new TextEditingController();
TextEditingController txtTipoPreferencia = new TextEditingController();
TextEditingController txtCalle = new TextEditingController();
TextEditingController txtCP = new TextEditingController();
TextEditingController txtColonia = new TextEditingController();
TextEditingController txtnumExt = new TextEditingController();
TextEditingController txtnumInt = new TextEditingController();
TextEditingController txtCiudad = new TextEditingController();

/*                     Editar Datos Usuario                      */
///
TextEditingController txtEditName = new TextEditingController();
TextEditingController txtEditApellido = new TextEditingController();
TextEditingController txtEditNumCel =
    new TextEditingController(text: NoCel.text);
TextEditingController txtEditFechaNac = new TextEditingController();
TextEditingController txtEditTipoPreferencia = new TextEditingController();
TextEditingController txtEditCalle = new TextEditingController();
TextEditingController txtEditCP = new TextEditingController();
TextEditingController txtEditColonia = new TextEditingController();
TextEditingController txtEditnumExt = new TextEditingController();
TextEditingController txtEditnumInt = new TextEditingController();
TextEditingController txtEditCiudad = new TextEditingController();

///

MaskedTextController horaEnt = new MaskedTextController(mask: '00:00');
MaskedTextController horaSal = new MaskedTextController(mask: '00:00');
MaskedTextController NoCel = new MaskedTextController(mask: '000 000 0000');
MaskedTextController NoCelEmp = new MaskedTextController(mask: '000 000 0000');

/*==============================Datos Tarjeta=================================*/
TextEditingController txtTarjetaNombre = new TextEditingController();
TextEditingController txtTarjetaAlias = new TextEditingController();
TextEditingController txtTarjetaMesVen = new TextEditingController();
TextEditingController txtTarjetaAnoVen = new TextEditingController();
TextEditingController txtTarjetaCodSeg = new TextEditingController();
MaskedTextController NoTarjeta =
    new MaskedTextController(mask: '0000 0000 0000 0000');
MaskedTextController NoTarjetaOculta =
    new MaskedTextController(mask: '**** **** **** 0000');
/*==============================Datos Tarjeta=================================*/
TextEditingController txtHoraEnt =
    new TextEditingController(text: horaEnt.text);
TextEditingController txtHoraSal =
    new TextEditingController(text: horaSal.text);

TextEditingController txtNombreEmp = new TextEditingController();
TextEditingController txtDescripcionEmp = new TextEditingController();
TextEditingController txtTelefonoEmp =
    new TextEditingController(text: NoCelEmp.text);
TextEditingController txtDomicilioEmp = new TextEditingController();
TextEditingController txtTipoCategoriaEmp = new TextEditingController();
TextEditingController txtTipoRestaurantEmp = new TextEditingController();
TextEditingController txtSectorEmp = new TextEditingController();
TextEditingController txtDiasLaboralesEmp = new TextEditingController();
TextEditingController txtTipoServEmp = new TextEditingController();
TextEditingController txtHorarioEmp = new TextEditingController();
TextEditingController txtAM = new TextEditingController();
TextEditingController txtPM = new TextEditingController();

TextEditingController txtPlaNombre = new TextEditingController();
TextEditingController txtPlaDescripcion = new TextEditingController();
TextEditingController txtPlaTipoCategoria = new TextEditingController();
TextEditingController txtPlaSubCategoria = new TextEditingController();
TextEditingController txtPlaPrecio =
    new TextEditingController(text: MaskPrecioPlo.text);
TextEditingController txtPlaExtras = new TextEditingController();

MoneyMaskedTextController MaskPrecioPlo = new MoneyMaskedTextController(
  decimalSeparator: '.',
  thousandSeparator: ',',
  leftSymbol: '\$',
);

/*
* AddCarrito
*/
TextEditingController txtCarritoNom = new TextEditingController();
TextEditingController txtCarritoCant = new TextEditingController();
TextEditingController txtCarritoDesc = new TextEditingController();
TextEditingController txtCarritoNota = new TextEditingController();
TextEditingController txtReferenciaEnvio = new TextEditingController();

/*
* Configuracion Restaurant
*/
TextEditingController txtComisionEnvio = new TextEditingController();
TextEditingController txtIdComisionEnvio = new TextEditingController();
