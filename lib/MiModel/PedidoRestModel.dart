class PedidoRestModel{
  int PedidoRestaurantid_PedidoRestaurant;
  int PedidoRestaurantid_usuario;
  int PedidoRestaurantid_menu;
  int PedidoRestaurantid_Restaurant;
  int PedidoRestaurantCantidad;
  String PedidoRestaurantComentarios;
  int PedidoRestaurantEstatus;
  String EstatusCodigo;
  String RestaurantNombre;
  String UsuarioNumCel;
  String UsuarioNombre;
  String UsuarioApellido;
  String UsuarioCalle;
  String UsuarioCP;
  String UsuarioColonia;
  int UsuarioNumExt;
  int UsuarioNumInt;
  String UsuarioCiudad;
  String UsuarioFoto;
  String menuNombre;
  String menufoto;
  int PedidoRestaurantid_Pedido;
  int PedidoRestaurantid_PedidoDetalle;
  String Ubicacion;
  String UbicacionCP;
  double Latitud;
  double Longitud;

  PedidoRestModel({
    this.PedidoRestaurantid_PedidoRestaurant,
    this.PedidoRestaurantid_usuario,
    this.PedidoRestaurantid_menu,
    this.PedidoRestaurantid_Restaurant,
    this.PedidoRestaurantCantidad,
    this.PedidoRestaurantComentarios,
    this.PedidoRestaurantEstatus,
    this.EstatusCodigo,
    this.RestaurantNombre,
    this.UsuarioNumCel,
    this.UsuarioNombre,
    this.UsuarioApellido,
    this.UsuarioCalle,
    this.UsuarioCP,
    this.UsuarioColonia,
    this.UsuarioNumExt,
    this.UsuarioNumInt,
    this.UsuarioCiudad,
    this.UsuarioFoto,
    this.menuNombre,
    this.menufoto,
    this.PedidoRestaurantid_Pedido,
    this.PedidoRestaurantid_PedidoDetalle,
    this.Ubicacion,
    this.UbicacionCP,
    this.Latitud,
    this.Longitud
  });

  factory PedidoRestModel.fromJson(Map<String, dynamic> json) => PedidoRestModel(
      PedidoRestaurantid_PedidoRestaurant: json["PedidoRestaurantid_PedidoRestaurant"],
      PedidoRestaurantid_usuario: json["PedidoRestaurantid_usuario"],
      PedidoRestaurantid_menu: json["PedidoRestaurantid_menu"],
      PedidoRestaurantid_Restaurant: json["PedidoRestaurantid_Restaurant"],
      PedidoRestaurantCantidad: json["PedidoRestaurantCantidad"],
      PedidoRestaurantComentarios: json["PedidoRestaurantComentarios"],
      PedidoRestaurantEstatus: json["PedidoRestaurantEstatus"],
      EstatusCodigo: json["EstatusCodigo"],
      RestaurantNombre: json["RestaurantNombre"],
      UsuarioNumCel: json["UsuarioNumCel"],
      UsuarioNombre: json["UsuarioNombre"],
      UsuarioApellido: json["UsuarioApellido"],
      UsuarioCalle: json["UsuarioCalle"],
      UsuarioCP: json["UsuarioCP"],
      UsuarioColonia: json["UsuarioColonia"],
      UsuarioNumExt: json["UsuarioNumExt"],
      UsuarioNumInt: json["UsuarioNumInt"],
      UsuarioCiudad: json["UsuarioCiudad"],
      UsuarioFoto: json["UsuarioFoto"],
      menuNombre: json["menuNombre"],
      menufoto: json["menufoto"],
      PedidoRestaurantid_Pedido: json["PedidoRestaurantid_Pedido"],
      PedidoRestaurantid_PedidoDetalle: json["PedidoRestaurantid_PedidoDetalle"],
      Ubicacion: json["Ubicacion"],
      UbicacionCP: json["UbicacionCP"],
      Latitud: json["Latitud"],
      Longitud: json["Longitud"]
  );

  Map<String, dynamic> toJson() => {
    "PedidoRestaurantid_PedidoRestaurant": PedidoRestaurantid_PedidoRestaurant,
    "PedidoRestaurantid_usuario": PedidoRestaurantid_usuario,
    "PedidoRestaurantid_menu": PedidoRestaurantid_menu,
    "PedidoRestaurantid_Restaurant": PedidoRestaurantid_Restaurant,
    "PedidoRestaurantCantidad": PedidoRestaurantCantidad,
    "PedidoRestaurantComentarios": PedidoRestaurantComentarios,
    "PedidoRestaurantEstatus": PedidoRestaurantEstatus,
    "EstatusCodigo": EstatusCodigo,
    "RestaurantNombre": RestaurantNombre,
    "UsuarioNumCel": UsuarioNumCel,
    "UsuarioNombre": UsuarioNombre,
    "UsuarioApellido": UsuarioApellido,
    "UsuarioCalle": UsuarioCalle,
    "UsuarioCP": UsuarioCP,
    "UsuarioColonia": UsuarioColonia,
    "UsuarioNumExt": UsuarioNumExt,
    "UsuarioNumInt": UsuarioNumInt,
    "UsuarioCiudad": UsuarioCiudad,
    "UsuarioFoto": UsuarioFoto,
    "menuNombre": menuNombre,
    "menufoto": menufoto,
    "PedidoRestaurantid_Pedido": PedidoRestaurantid_Pedido,
    "PedidoRestaurantid_PedidoDetalle": PedidoRestaurantid_PedidoDetalle,
    "Ubicacion": Ubicacion,
    "UbicacionCP": UbicacionCP,
    "Latitud": Latitud,
    "Longitud": Longitud
  };
}