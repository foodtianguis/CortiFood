import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:flutter/material.dart';
//import 'package:stripe_native/stripe_native.dart';

class NativePay extends StatefulWidget {
  @override
  _NativePayState createState() => _NativePayState();
}

class _NativePayState extends State<NativePay> {

  @override
  void initState() {
    super.initState();
    /*StripeNative.setPublishableKey("pk_live_51IykDEHwUHMi8YMJBPQmZnfoilB2lNzcIxvn6CMDIJXYryTi9J89UOkSwXFxmzPsKj6UE5wPdrgtISZSabOfZ53700sVC4Ksm7",);
    StripeNative.setMerchantIdentifier("9384-2203-0379");
    StripeNative.setCurrencyKey("MXN");
    StripeNative.setCountryKey("Mexico");*/
  }
/*
  Future<String> get receiptPayment async {
    /* custom receipt w/ useReceiptNativePay */
    const receipt = <String, double>{"Nice Hat": 5.00, "Used Hat" : 1.50};
    var aReceipt = Receipt(receipt, sNomApp);
    return await StripeNative.useReceiptNativePay(aReceipt);
  }

  Future<String> get orderPayment async {
    // subtotal, tax, tip, merchant name
    var order = Order(1.0, 0.0, 0.0, sNomApp);
    return await StripeNative.useNativePay(order);
  }
*/
  Widget get nativeButton => Padding(padding: EdgeInsets.all(10), child: RaisedButton(padding: EdgeInsets.all(10),
      child: Text("Native Pay"),
      onPressed: () async {

        //var token = await orderPayment;
        //var token = await receiptPayment;

        //print(token);
        /* After using the plugin to get a token, charge that token. On iOS the Apple-Pay sheet animation will signal failure or success using confirmPayment. Google-Pay does not have a similar implementation, so I may flash a SnackBar using wasCharged in a real application.
          call own charge endpoint w/ token
          const wasCharged = await AppAPI.charge(token, amount);
          then show success or failure
          StripeNative.confirmPayment(wasCharged);
          */
        // Until this method below is called, iOS will spin a loading indicator on the Apple-Pay sheet
        //StripeNative.confirmPayment(true); // iOS load to check.
        // StripeNative.confirmPayment(false); // iOS load to X.

      }
  ));

  @override
  Widget build(BuildContext context) =>  nativeButton;


}