class BusquedaModel {
  int id_menu;
  String menuNombre;
  String menuDescripcion;
  double Precio;
  String menufoto;
  int id_restaurant;
  String RestaurantNombre;
  String RestaurantDescripcion;
  int RestaurantTipoCategoria;
  String RestaurantDomicilio;
  int RestaurantSector;
  String RestaurantDiasLaborales;
  String Restauranthorario;
  String Restaurantlogo;
  double Restaurantlatitud;
  double Restaurantlongitud;
  String RestaurantTipoServ;
  String TipoCategoriaDescripcion;
  bool TiendaAbierta;

  BusquedaModel({this.id_menu,
    this.menuNombre,
    this.menuDescripcion,
    this.Precio,
    this.menufoto,
    this.id_restaurant,
    this.RestaurantNombre,
    this.RestaurantDescripcion,
    this.RestaurantTipoCategoria,
    this.RestaurantDomicilio,
    this.RestaurantSector,
    this.RestaurantDiasLaborales,
    this.Restauranthorario,
    this.Restaurantlogo,
    this.Restaurantlatitud,
    this.Restaurantlongitud,
    this.RestaurantTipoServ,
    this.TipoCategoriaDescripcion,
    this.TiendaAbierta});

  factory BusquedaModel.fromJson(Map<String, dynamic> json) => BusquedaModel(
    id_menu: json["id_menu"],
    menuNombre: json["menuNombre"],
    menuDescripcion: json["menuDescripcion"],
    Precio: json["Precio"],
    menufoto: json["menufoto"],
    id_restaurant: json["id_Restaurant"],
    RestaurantNombre: json["RestaurantNombre"],
    RestaurantDescripcion: json["RestaurantDescripcion"],
    RestaurantTipoCategoria: json["RestaurantTipoCategoria"],
    RestaurantDomicilio: json["RestaurantDomicilio"],
    RestaurantSector: json["RestaurantSector"],
    RestaurantDiasLaborales: json["RestaurantDiasLaborales"],
    Restauranthorario: json["Restauranthorario"],
    Restaurantlogo: json["Restaurantlogo"],
    Restaurantlatitud: json["Restaurantlatitud"],
    Restaurantlongitud: json["Restaurantlongitud"],
    RestaurantTipoServ: json["RestaurantTipoServ"],
    TipoCategoriaDescripcion: json["TipoCategoriaDescripcion"],
    TiendaAbierta: json["TiendaAbierta"]
  );

  Map<String, dynamic> toJson() => {
    "id_menu": id_menu,
    "menuNombre": menuNombre,
    "menuDescripcion": menuDescripcion,
    "Precio": Precio,
    "menufoto": menufoto,
    "id_restaurant": id_restaurant,
    "RestaurantNombre": RestaurantNombre,
    "RestaurantDescripcion": RestaurantDescripcion,
    "RestaurantTipoCategoria": RestaurantTipoCategoria,
    "RestaurantDomicilio": RestaurantDomicilio,
    "RestaurantSector": RestaurantSector,
    "RestaurantDiasLaborales": RestaurantDiasLaborales,
    "Restauranthorario": Restauranthorario,
    "Restaurantlogo": Restaurantlogo,
    "Restaurantlatitud": Restaurantlatitud,
    "Restaurantlongitud": Restaurantlongitud,
    "RestaurantTipoServ": RestaurantTipoServ,
    "TipoCategoriaDescripcion": TipoCategoriaDescripcion,
    "TiendaAbierta": TiendaAbierta
  };
}
