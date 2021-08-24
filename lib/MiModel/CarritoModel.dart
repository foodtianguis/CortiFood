class CarritoModel{
  int Carritoid_Carrito;
  int Carritoid_Usuario;
  double CarritoPrecioCarrito;
  int CarritoDetalleid_CarritoDetalle;
  int CarritoDetalleid_menu;
  int CarritoDetalleCantidad;
  String CarritoDetalleComentarios;
  String menuNombre;
  String menuDescripcion;
  double menuPrecio;
  String menuExtras;
  String menufoto;
  String RestaurantNombre;
  bool FNActiva;

  CarritoModel({
    this.Carritoid_Carrito,
    this.Carritoid_Usuario,
    this.CarritoPrecioCarrito,
    this.CarritoDetalleid_CarritoDetalle,
    this.CarritoDetalleid_menu,
    this.CarritoDetalleCantidad,
    this.CarritoDetalleComentarios,
    this.menuNombre,
    this.menuDescripcion,
    this.menuPrecio,
    this.menuExtras,
    this.menufoto,
    this.RestaurantNombre,
    this.FNActiva,
  });

  factory CarritoModel.fromJson(Map<String, dynamic> json) => CarritoModel(
      Carritoid_Carrito: json["Carritoid_Carrito"],
      Carritoid_Usuario: json["Carritoid_Usuario"],
      CarritoPrecioCarrito: json["CarritoPrecioCarrito"],
      CarritoDetalleid_CarritoDetalle: json["CarritoDetalleid_CarritoDetalle"],
      CarritoDetalleid_menu: json["CarritoDetalleid_menu"],
      CarritoDetalleCantidad: json["CarritoDetalleCantidad"],
      CarritoDetalleComentarios: json["CarritoDetalleComentarios"],
      menuNombre: json["menuNombre"],
      menuDescripcion: json["menuDescripcion"],
      menuPrecio: json["menuPrecio"],
      menuExtras: json["menuExtras"],
      menufoto: json["menufoto"],
      RestaurantNombre: json["RestaurantNombre"],
      FNActiva: json["FNActiva"]
  );

  Map<String, dynamic> toJson() => {
    "Carritoid_Carrito": Carritoid_Carrito,
    "Carritoid_Usuario": Carritoid_Usuario,
    "CarritoPrecioCarrito": CarritoPrecioCarrito,
    "CarritoDetalleid_CarritoDetalle": CarritoDetalleid_CarritoDetalle,
    "CarritoDetalleid_menu": CarritoDetalleid_menu,
    "CarritoDetalleCantidad": CarritoDetalleCantidad,
    "CarritoDetalleComentarios": CarritoDetalleComentarios,
    "menuNombre": menuNombre,
    "menuDescripcion": menuDescripcion,
    "menuPrecio": menuPrecio,
    "menuExtras": menuExtras,
    "menufoto": menufoto,
    "RestaurantNombre": RestaurantNombre,
    "FNActiva": FNActiva
  };
}