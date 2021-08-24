import 'dart:convert';
import 'dart:ffi';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/Pagos/MiWidgetTarjeta.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:dartxero/MiFramework/MiEstilos.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiModel/TarjetaModel.dart';
import 'package:flutter/material.dart';
import 'package:dartxero/MiFramework/MiControllerGlobales.dart' as ctrl;

void AddTarjeta(BuildContext context, int id_Usuario) {
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
                  child: FormTarjeta(nAccion: 1,Tarjeta: null,),
                ),
              ],
            )
        );
      });
}

class FormTarjeta extends StatefulWidget{
  final int nAccion; // 1 Agregar Tarjeta y 2 Modificar Tarjeta
  final TarjetaModel Tarjeta;

  const FormTarjeta({Key key, this.nAccion, this.Tarjeta}) : super(key: key);
  @override
  _FormTarjeta createState() => _FormTarjeta();
}

class _FormTarjeta extends State<FormTarjeta>{

  String _cardNumber;
  String _DateExpiret;
  String _CardNombre;
  String _cvv;
  Color _ColorTarjeta;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ctrl.txtTarjetaNombre.text = "";
    ctrl.txtTarjetaAlias.text = "";
    ctrl.txtTarjetaMesVen.text = "";
    ctrl.txtTarjetaAnoVen.text = "";
    ctrl.txtTarjetaCodSeg.text = "";
    ctrl.NoTarjeta.text = "";
    ctrl.NoTarjetaOculta.text = "";
    _cardNumber = "";
    _DateExpiret = "";
    _CardNombre = "";
    _ColorTarjeta = ColorApp;
    _cvv = "";

    if (widget.nAccion == 2){
      ctrl.txtTarjetaNombre.text = widget.Tarjeta.Nombre;
      ctrl.txtTarjetaAlias.text = widget.Tarjeta.Alias;
      ctrl.txtTarjetaMesVen.text = widget.Tarjeta.MesVen;
      ctrl.txtTarjetaAnoVen.text = widget.Tarjeta.AnoVen;
      ctrl.txtTarjetaCodSeg.text = widget.Tarjeta.CodSeg;
      ctrl.NoTarjeta.text = widget.Tarjeta.NoTarjeta;
      ctrl.NoTarjetaOculta.text = widget.Tarjeta.NoTarjeta;

      _cardNumber = widget.Tarjeta.NoTarjeta;
      _DateExpiret = "${widget.Tarjeta.MesVen}/${widget.Tarjeta.AnoVen}";
      _CardNombre = widget.Tarjeta.Nombre;
      _cvv = widget.Tarjeta.CodSeg;
    }
  }

  ListView TarjetaDebito(){
    return ListView(
      children: [
        MiWidgetTarjeta(
        cardNumber: _cardNumber,
        expiryDate: _DateExpiret,
        cardHolderName: _CardNombre,
        cvvCode: _cvv != null? _cvv : '',
        labelCardHolder: sNombreTitular,
        showBackView: false,
        obscureCardNumber: widget.nAccion == 2,
        obscureCardCvv: widget.nAccion == 2,
        cardBgColor:  _ColorTarjeta,
      ),
      CreditCardForm(
        formKey: _formKey, // Required
        onCreditCardModelChange: (CreditCardModel data) {
          setState(() {
            if (data.cardNumber != _cardNumber)
              _cardNumber = data.cardNumber;
            if (data.expiryDate != _DateExpiret)
              _DateExpiret = data.expiryDate;
            if (data.cardHolderName != _CardNombre)
              _CardNombre = data.cardHolderName;
            if (data.cvvCode != _cvv)
              _cvv = data.cvvCode;

            //_ColorTarjeta = ColorTarjeta(_cardNumber);
          });
        }, //// Requ
        cardNumber: _cardNumber,// red
        expiryDate: _DateExpiret,
        cardHolderName: _CardNombre,
        themeColor: ColorApp,
        obscureCvv: widget.nAccion == 2,
        obscureNumber: widget.nAccion == 2,
        cvvValidationMessage: cvvValidationMessage,
        dateValidationMessage: dateValidationMessage,
        numberValidationMessage: numberValidationMessage,
        cardNumberDecoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: sNumeroTarjeta,
          hintText: 'XXXX XXXX XXXX XXXX',
        ),
        expiryDateDecoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: sFechaVen,
          hintText: 'XX/XX',
        ),
        cvvCodeDecoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: sCVV,
          hintText: 'XXX',
        ),
        cardHolderDecoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: sNombreTitular,
        ),

      ),
      SizedBox(height: 15,),
      Container(
        child: TextFormField(
          controller: ctrl.txtTarjetaAlias,
          decoration: InputDecoration(border: OutlineInputBorder(),labelText: sAlias),
          validator: (value){
            if (value.isEmpty) {
              return sMensajeErrorComp(sAlias);
            }
            return null;
          },
        ),
        margin: EdgeInsets.symmetric(horizontal: 15),
      ),
      SizedBox(height: 15,),
      Container(
        child: RaisedButton(
          child: Text(sGuardar),
          onPressed: (){
            String sError = "";
            if (_cardNumber.isEmpty)
              sError = sNumeroTarjeta;
            if (_DateExpiret.isEmpty)
              sError = !sError.isEmpty? "${sError}\nFecha Vencimiento": "Fecha Vencimiento";
            if (_CardNombre.isEmpty)
              sError = !sError.isEmpty ? "${sError}\n${sNombreTitular}": sNombreTitular;
            if (ctrl.txtTarjetaAlias.text.isEmpty)
              sError = !sError.isEmpty ? "${sError}\n${sAlias}": sAlias;

            //if (_cvv.isEmpty)
              //sError = "";
            if (sError.isEmpty) {
              var DateExpiret = _DateExpiret.split('/');
              ctrl.txtTarjetaMesVen.text = DateExpiret[0];
              ctrl.txtTarjetaAnoVen.text = DateExpiret[1];

              ctrl.txtTarjetaNombre.text = _CardNombre;
              ctrl.txtTarjetaCodSeg.text = _cvv;
              ctrl.NoTarjeta.text = _cardNumber;

              AddTarjeta();
              Navigator.pop(context);
            }
            else{
              vMensajeSys(context, sError, 1);
            }

          },
        ),
        margin: EdgeInsets.symmetric(horizontal: 15),
      ),
    ],);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: TarjetaDebito(),
    );
  }


  Map<CardType, Set<List<String>>> cardNumPatterns =
  <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  Color ColorTarjeta(sNumeroTarjeta){
    CardType Tarjeta = detectCCType(sNumeroTarjeta);

    switch(Tarjeta){
      case CardType.mastercard:
        return Colors.blue;
        break;
      case CardType.visa:
        return Colors.blue[800];
        break;
      case CardType.americanExpress:
        return Colors.green;
        break;
      case CardType.discover:
        return Colors.red;
        break;
      case CardType.otherBrand:
        return ColorApp;
        break;

    }
  }

  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
          (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
          cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  Future<void> AddTarjeta() async {
    //final repose = await http.post("${sURL}Usuario/AddTarjeta",
    final repose = await http.post(CadenaConexion('/Usuario/AddTarjeta'),
      body: {
        "id_Usuario": user.id.toString(),
        "Nombre": ctrl.txtTarjetaNombre.text,
        "Alias": ctrl.txtTarjetaAlias.text,
        "MesVen": ctrl.txtTarjetaMesVen.text,
        "AnoVen": ctrl.txtTarjetaAnoVen.text,
        "CodSeg": ctrl.txtTarjetaCodSeg.text,
        "NoTarjeta": ctrl.NoTarjeta.text,
        "TipoUsuario": user.TipoUsuario.toString(),
        "Estatus": "ACTIVO",
        "EsDefault": "0",
      }
    );

    if (repose.statusCode == 200 || repose.statusCode == 201) {
      Navigator.pop(context);
    } else {
      throw Exception("Fallo!");
    }
  }
}
