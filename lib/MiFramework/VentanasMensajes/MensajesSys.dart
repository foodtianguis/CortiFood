import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

void vMensajeSys(BuildContext context, String sMsj, int nTipo){
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
                  height: HeightVentana(sMsj),//200,
                  child: Column(
                    children: [
                      TipoIcon(nTipo),
                      SizedBox(height: 5,),
                      TipoMsj(nTipo),
                      SizedBox(height: 10,),
                      Expanded(child: FormatoMsj(sMsj)),
                    ],
                  ),
                ),
              ],
            )
        );
      });
}

Icon TipoIcon(int nTipo){
  switch (nTipo) {
    case 1: return Icon(Icons.error_outline,color: Colors.red,size: 100,);
    case 2: return Icon(Icons.warning_amber_outlined,color: Colors.amber,size: 100,);
    case 3: return Icon(Icons.info_outline,color: Colors.blue,size: 100,);
    case 4: return Icon(Icons.message_outlined,color: Colors.blue,size: 100,);
  }
}

Text TipoMsj(int nTipo){
  switch (nTipo) {
    case 1: return Text("Error:",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,),);
    case 2: return Text("Advertencia:",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,),);
    case 3: return Text("Información:",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,),);
    case 4: return Text("Mensaje:",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,),);
  }
}

Text FormatoMsj(String sMsj){
  int numLines = '\n'.allMatches(sMsj).length + 1;

  return Text(sMsj,maxLines: numLines,);
}

double HeightVentana(String sMsj){
  int numLines = '\n'.allMatches(sMsj).length + 1;
  double Result = numLines > 2? 200 + (numLines * 10.0): 200;
  return Result;
}

void vMensajeSysIOS(BuildContext context, String sMsj, int nTipo){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: 200,
                  child: Column(
                    children: [
                      TipoIcon(nTipo),
                      SizedBox(height: 5,),
                      TipoMsj(nTipo),
                      SizedBox(height: 10,),
                      Text(sMsj,maxLines: 2,),
                    ],
                  ),
                ),
              ],
            )
        );
      });
}
