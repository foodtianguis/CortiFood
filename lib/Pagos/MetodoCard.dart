import 'dart:io';

import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/Pagos/Button.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_paystack/flutter_paystack.dart';

class MetodoCard extends StatefulWidget {
  @override
  _CheckoutMethodCardState createState() => _CheckoutMethodCardState();
}

// Pay public key
class _CheckoutMethodCardState extends State<MetodoCard> {
//  final _PaystackPlugin = PaystackPlugin();

  @override
  void initState() {
//    _PaystackPlugin.initialize(publicKey: "pk_live_51IykDEHwUHMi8YMJBPQmZnfoilB2lNzcIxvn6CMDIJXYryTi9J89UOkSwXFxmzPsKj6UE5wPdrgtISZSabOfZ53700sVC4Ksm7");

    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: hexToColor("#41aa5e"),
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    );
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
/*
  PaymentCard Tarjeta(){
    return PaymentCard(number: "0000000000000000", expiryMonth: 1, expiryYear: 20)
            ..country = 'Mexico'
    ;

  }

  chargeCard() async {
    Charge charge = Charge()
      ..card = Tarjeta()
      ..amount = 10
      ..reference = _getReference()
      ..email = 'foodtianguis@gmail.com'
      ..putCustomField('Charged From', sNomApp)
      ..currency = 'MXN'
      ..locale = 'es_MX'
    ;
    CheckoutResponse response = await _PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      hideEmail: true,
      charge: charge,
    );
    if (response.status == true) {
      _showDialog();
    } else {
      _showErrorDialog();
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pop up method",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Button(
              child: Text("Charge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
             // onClick: () => chargeCard(),
            ),
          )),
    );
  }
}