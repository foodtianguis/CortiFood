class PedidoModel{
  int PedidoDetalleid_PedidoDetalle;
  int PedidoDetalleid_menu;
  int PedidoDetalleCantidad;
  String PedidoDetalleComentarios;
  int PedidoDetalleid_Carrito;
  int PedidoDetalleid_CarritoDetalle;
  int Pedidoid_Pedido;
  int Pedidoid_Usuario;
  String PedidoFechaPedido;
  double PedidoTotalPedido;
  String EstatusDescripcion;
  String menumenuNombre;
  String menumenuDescripcion;
  double menumenuPrecio;
  String menumenuExtras;
  String menumenufoto;
  int menuRestaurantid_Restaurant;
  String menuRestaurantNombre;
  String menuRestaurantlogo;
  double menuRestaurantlatitud;
  double menuRestaurantlongitud;
  String EstatusCodigo;

  PedidoModel({
    this.PedidoDetalleid_PedidoDetalle,
    this.PedidoDetalleid_menu,
    this.PedidoDetalleCantidad,
    this.PedidoDetalleComentarios,
    this.PedidoDetalleid_Carrito,
    this.PedidoDetalleid_CarritoDetalle,
    this.Pedidoid_Pedido,
    this.Pedidoid_Usuario,
    this.PedidoFechaPedido,
    this.PedidoTotalPedido,
    this.EstatusDescripcion,
    this.menumenuNombre,
    this.menumenuDescripcion,
    this.menumenuPrecio,
    this.menumenuExtras,
    this.menumenufoto,
    this.menuRestaurantid_Restaurant,
    this.menuRestaurantNombre,
    this.menuRestaurantlogo,
    this.menuRestaurantlatitud,
    this.menuRestaurantlongitud,
    this.EstatusCodigo
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) => PedidoModel(
      PedidoDetalleid_PedidoDetalle: json["PedidoDetalleid_PedidoDetalle"],
      PedidoDetalleid_menu: json["PedidoDetalleid_menu"],
      PedidoDetalleCantidad: json["PedidoDetalleCantidad"],
      PedidoDetalleComentarios: json["PedidoDetalleComentarios"],
      PedidoDetalleid_Carrito: json["PedidoDetalleid_Carrito"],
      PedidoDetalleid_CarritoDetalle: json["PedidoDetalleid_CarritoDetalle"],
      Pedidoid_Pedido: json["Pedidoid_Pedido"],
      Pedidoid_Usuario: json["Pedidoid_Usuario"],
      PedidoFechaPedido: json["PedidoFechaPedido"],
      PedidoTotalPedido: json["PedidoTotalPedido"],
      EstatusDescripcion: json["EstatusDescripcion"],
      menumenuNombre: json["menumenuNombre"],
      menumenuDescripcion: json["menumenuDescripcion"],
      menumenuPrecio: json["menumenuPrecio"],
      menumenuExtras: json["menumenuExtras"],
      menumenufoto: json["menumenufoto"],
      menuRestaurantid_Restaurant: json["menuRestaurantid_Restaurant"],
      menuRestaurantNombre: json["menuRestaurantNombre"],
      menuRestaurantlogo: json["menuRestaurantlogo"],
      menuRestaurantlatitud: json["menuRestaurantlatitud"],
      menuRestaurantlongitud: json["menuRestaurantlongitud"],
      EstatusCodigo: json["EstatusCodigo"]
  );

  Map<String, dynamic> toJson() => {
    "PedidoDetalleid_PedidoDetalle": PedidoDetalleid_PedidoDetalle,
    "PedidoDetalleid_menu": PedidoDetalleid_menu,
    "PedidoDetalleCantidad": PedidoDetalleCantidad,
    "PedidoDetalleComentarios": PedidoDetalleComentarios,
    "PedidoDetalleid_Carrito": PedidoDetalleid_Carrito,
    "PedidoDetalleid_CarritoDetalle": PedidoDetalleid_CarritoDetalle,
    "Pedidoid_Pedido": Pedidoid_Pedido,
    "Pedidoid_Usuario": Pedidoid_Usuario,
    "PedidoFechaPedido": PedidoFechaPedido,
    "PedidoTotalPedido": PedidoTotalPedido,
    "EstatusDescripcion": EstatusDescripcion,
    "menumenuNombre": menumenuNombre,
    "menumenuDescripcion": menumenuDescripcion,
    "menumenuPrecio": menumenuPrecio,
    "menumenuExtras": menumenuExtras,
    "menumenufoto": menumenufoto,
    "menuRestaurantid_Restaurant": menuRestaurantid_Restaurant,
    "menuRestaurantNombre": menuRestaurantNombre,
    "menuRestaurantlogo": menuRestaurantlogo,
    "menuRestaurantlatitud": menuRestaurantlatitud,
    "menuRestaurantlongitud": menuRestaurantlongitud,
    "EstatusCodigo": EstatusCodigo
  };
}