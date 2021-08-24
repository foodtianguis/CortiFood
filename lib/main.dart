import 'package:dartxero/MiFramework/Notificaciones.dart';
import 'package:dartxero/MiFramework/RecordarDatos.dart';
import 'package:dartxero/MiPantallas/AddEmpresa.dart';
import 'package:dartxero/MiPantallas/BandejaEntrada.dart';
import 'package:dartxero/MiPantallas/BandejaRestaurant.dart';
import 'package:dartxero/MiPantallas/BandejaUsuario.dart';
import 'package:dartxero/MiPantallas/Busqueda/BusquedaDetalle.dart';
import 'package:dartxero/MiPantallas/Pedido/ViewPedidoRest.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'MiConfiguracion/ConfiguracionRestaurant.dart';
import 'MiFramework/MiAcciones.dart';
import 'MiPantallas/AddUser.dart';
import 'login.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  //debugPaintSizeEnabled=true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: sNomApp,
      theme: ThemeData(
        primaryColor: ColorApp,
        primarySwatch: ColorAppMat,
        primaryTextTheme: TextTheme(
            button: EstiloLetraBtn, body1: EstiloLetraLB, title: EstiloTitulos),
        cursorColor: ColorApp,
        primaryIconTheme: ColorBtnTxtTheme,
        brightness: Brightness.light,
        //brightness: Brightness.dark,
        //accentColor: ColorAppMat,
        //canvasColor: Colors.transparent,

        backgroundColor: ColorFondo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: sNomApp,
      ),
      //initialRoute: "/MyHomePage",
      routes: <String, WidgetBuilder>{
        '/BandejaUs': (BuildContext context) => new Bandeja(),
        '/BandejaUser': (BuildContext context) => new BandejaUsuario(
              nIndex: 0,
              nOpcion: 0,
              busqueda: null,
              Bcontext: context,
            ),
        '/BandejaUserCarrito': (BuildContext context) => new BandejaUsuario(
              nIndex: 1,
              nOpcion: 0,
              busqueda: null,
              Bcontext: context,
            ),
        '/BandejaUserPedido': (BuildContext context) => new BandejaUsuario(
              nIndex: 2,
              nOpcion: 0,
              busqueda: null,
              Bcontext: context,
            ),
        //'/BandejaUserViewMenu': (BuildContext context) => new BandejaUsuario(nIndex: 1,nOpcion: 1,busqueda: null,),
        '/BandejaRest': (BuildContext context) => new BandejaRestaurant(
              nIndex: 0,
            ),
        '/BandejaRestPedido': (BuildContext context) => new BandejaRestaurant(
              nIndex: 1,
            ),
        '/ViewRestPedido': (BuildContext context) => new ViewPedidoRest(
              id_Restaurant: Restaurant.id_Restaurant,
            ),
        '/RestBusquedaColonia': (BuildContext context) => new BandejaRestaurant(
              nIndex: 3,
            ),
        '/loginPage': (BuildContext context) => new loginPage(),
        '/MyHomePage': (BuildContext context) => new MyHomePage(),
        '/AddUser': (BuildContext context) => new AddDatosUsers(),
        '/AddDomicilioUsers': (BuildContext context) => new AddDomicilioUsers(),
        '/AddUserEmpresa': (BuildContext context) => new AddUserEmpresa(),
        '/AddDatoEmpresa': (BuildContext context) => new AddDatosEmpresa(),
        '/BusquedaDetalle': (BuildContext context) => new BusquedaDetalle(),
        '/ConfiguracionRestaurant': (BuildContext context) =>
            new ConfiguracionRestaurant(),

        //'/HomeScreen': (BuildContext context)=> new FechasSys(),
      },
    );
    /*var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Pide...',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          primarySwatch: ColorAppMat,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );*/
/*    return RefreshConfiguration(
                hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
                child: MaterialApp(
                  home: MyHomePage(),
                  routes: <String, WidgetBuilder>{
                    '/BandejaUs': (BuildContext context) => new Bandeja(),
                    '/loginPage': (BuildContext context) => new loginPage(),
                    '/MyHomePage': (BuildContext context) => new MyHomePage(),
                    '/AddUser': (BuildContext context) => new AddDatosUsers(),
                    '/AddDomicilioUsers': (BuildContext context) => new AddDomicilioUsers(),
                    '/AddUserEmpresa': (BuildContext context) => new AddUserEmpresa(),
                    '/AddDatoEmpresa': (BuildContext context) => new AddDatosEmpresa(),
                    //'/HomeScreen': (BuildContext context)=> new FechasSys(),
                  },
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: ColorAppMat,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  locale: LocaleModel.locale,
                  localizationsDelegates: const [
                    L.delegate,
                    RefreshLocalizations.delegate,

                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: L.delegate.supportedLocales,
                ),
              );
*/
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyPreferences _myPreferences = MyPreferences();

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: Bandeja(),
        backgroundColor: ColorApp,
        //image: Image.asset('Utilerias/Imagen/AskmeInicio.png',height: 250,width: 250,),
        //image: Image.asset('Utilerias/Imagen/gulaInicio.png',height: 250,width: 250,),
        image: Image.asset(
          'Utilerias/Imagen/gulaConiracGrnade.png',
        ),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        //onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.orange[900]);
    /*

      Scaffold(
        // appBar: AppBar(title: Text(sNomApp),),
        body: Bandeja(),
      backgroundColor: ColorFondoApp,
    );*/
  }

  @override
  void initState() {
    super.initState();
    _myPreferences.init().then((value) {
      //if(mounted) {
      setState(() {
        _myPreferences = value;
      });
      //}
    });
  }
}
