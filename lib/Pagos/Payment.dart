import 'dart:convert';
import 'dart:io';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/Pagos/ShowDialogToDismiss.dart';
import 'package:flutter/material.dart';
//import 'package:stripe_payment/stripe_payment.dart';

class PaymentClass extends StatefulWidget {
  @override
  _PaymentClass createState() => new _PaymentClass();
}

class _PaymentClass extends State<PaymentClass> {
  //Token _paymentToken;
  //PaymentMethod _paymentMethod;
  String _error;

  //this client secret is typically created by a backend system
  //check https://stripe.com/docs/payments/payment-intents#passing-to-client
  final String _paymentIntentClientSecret = null;

  //PaymentIntentResult _paymentIntent;
  //Source _source;

  ScrollController _controller = ScrollController();
/*
  final CreditCard testCard = CreditCard(
    number: '5204 1656 9171 7197',
    expMonth: 08,
    expYear: 25,
    country: "Mexico",
  );*/



  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();
/*
    StripePayment.setOptions(StripeOptions(
        merchantId: sNomApp,
        publishableKey: "pk_live_51IykDEHwUHMi8YMJBPQmZnfoilB2lNzcIxvn6CMDIJXYryTi9J89UOkSwXFxmzPsKj6UE5wPdrgtISZSabOfZ53700sVC4Ksm7",));
*/
  }
  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
               //   _source = null;
               ///   _paymentIntent = null;
               //   _paymentMethod = null;
               //   _paymentToken = null;
                });
              },
            )
          ],
        ),
        body: ListView(
          controller: _controller,
          padding: const EdgeInsets.all(20),
          children: <Widget>[/*
            RaisedButton(
              child: Text("Create Source"),
              onPressed: () {
                StripePayment.createSourceWithParams(SourceParams(
                  amount: 100,
                  currency: 'MXN',
                  email: "foodtianguis@gmail.com",
                )).then((source) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${source.sourceId}')));
                  setState(() {
                    _source = source;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Crear Pago por Card"),   //este
              onPressed: () {
                try {
                  StripePayment.createPaymentMethod(
                    PaymentMethodRequest(card: testCard,),).then((
                      paymentMethod) {
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                    setState(() {
                      _paymentMethod = paymentMethod;
                    });
                  }).catchError(setError);
                }
                on Exception catch(ex){

                }
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Confirm Payment Intent"),
              onPressed:
              _paymentMethod == null || _paymentIntentClientSecret == null
                  ? null
                  : () {
                StripePayment.confirmPaymentIntent(
                  PaymentIntent(
                    clientSecret: _paymentIntentClientSecret,
                    paymentMethodId: _paymentMethod.id,
                  ),
                ).then((paymentIntent) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text(
                "Confirm Payment Intent with saving payment method",
                textAlign: TextAlign.center,
              ),
              onPressed:
              _paymentMethod == null || _paymentIntentClientSecret == null
                  ? null
                  : () {
                StripePayment.confirmPaymentIntent(
                  PaymentIntent(
                    clientSecret: _paymentIntentClientSecret,
                    paymentMethodId: _paymentMethod.id,
                    isSavingPaymentMethod: true,
                  ),
                ).then((paymentIntent) {
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
                      content: Text(
                          'Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Authenticate Payment Intent"),
              onPressed: _paymentIntentClientSecret == null
                  ? null
                  : () {
                StripePayment.authenticatePaymentIntent(
                    clientSecret: _paymentIntentClientSecret)
                    .then((paymentIntent) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Native payment"),
              onPressed: () {
                if (Platform.isIOS) {
                  _controller.jumpTo(450);
                }
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                    totalPrice: "1.20",
                    currencyCode: "MXN",
                  ),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'MX',
                    currencyCode: 'MXN',
                    items: [
                      ApplePayItem(
                        label: 'Test',
                        amount: '13',
                      )
                    ],
                  ),
                ).then((token) {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    _paymentToken = token;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Complete Native Payment"),
              onPressed: () {
                StripePayment.completeNativePayRequest().then((_) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Completed successfully')));
                }).catchError(setError);
              },
            ),
            Divider(),
            Text('Current source:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current token:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentToken?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment method:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentMethod?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment intent:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentIntent?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current error: $_error'),*/
          ],
        ),
      ),
    );
  }
}