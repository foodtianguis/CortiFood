import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiUtilidad/AjustablePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class FechasSys extends StatefulWidget {
  @override
  _FechasSys createState() => _FechasSys();
}

class _FechasSys extends State<FechasSys> {
  String _date = sFechaNac;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showDatePicker(context,
              theme:
              DatePickerTheme(
                containerHeight: 150.0,
              ),
              showTitleActions: true,
              minTime: DateTime(1950, 01, 01),
              maxTime: DateTime(2022, 12, 31),
              onConfirm: (date) {
            print('confirm $date');
            //_date = '${date.year} - ${date.month} - ${date.day}';
            _date = '${date.day} / ${sRegresaMes(date.month)} / ${date.year}';
            sFechaNacCont = DateTime(date.year, date.month, date.day);
                setState(() {});
          }, currentTime: sFechaNacCont == null ? DateTime.now(): sFechaNacCont, locale: ConfLocal);
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
          )
        ),
         color: ColorFondoApp,
      ),
    );
  }
}



class Anio extends StatefulWidget{
  @override
  _Anio createState() => _Anio();
}

class _Anio extends State<Anio>{
  String _date = sFechaNac;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 4.0,
        onPressed: () {
          AjustablePicker.showDatePicker(context,
              theme:
              DatePickerTheme(
                containerHeight: 150.0,
              ),
              showTitleActions: true,
              minTime: DateTime(1950, 01, 01),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                print('confirm $date');
                //_date = '${date.year} - ${date.month} - ${date.day}';
                _date = '${date.year}';
                sFechaNacCont = DateTime(date.year);
                setState(() {});
              }, currentTime: sFechaNacCont == null ? DateTime.now(): sFechaNacCont, locale: ConfLocal);


          /*showBottomSheet(
              context: context,
              builder: (BuildContext context) => Container(
                width: MediaQuery.of(context).size.width,
                child: YearPicker(
                  initialDate: DateTime.now(),
                  currentDate: DateTime(int.tryParse(_date) != null? int.parse(_date) : 1992),
                  selectedDate: DateTime(1997),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _date = '${val.year}';
                    });
                    Navigator.pop(context);
                  },
                ),
              )
          );*/
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
            )
        ),
        color: ColorFondoApp,
      ),
    );
  }

}