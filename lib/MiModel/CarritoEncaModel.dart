class CarritoEncaModel{
  int id_Carrito;
  int id_Usuario;
  double PrecioCarrito;
  int CantidadRest;
  double ComisionTotal;
  String Direccion;

  CarritoEncaModel({
    this.id_Carrito,
    this.id_Usuario,
    this.PrecioCarrito,
    this.CantidadRest,
    this.ComisionTotal,
    this.Direccion,
  });

  factory CarritoEncaModel.fromJson(Map<String, dynamic> json) => CarritoEncaModel(
      id_Carrito: json["id_Carrito"],
      id_Usuario: json["id_Usuario"],
      PrecioCarrito: json["PrecioCarrito"],
      CantidadRest: json["CantidadRest"],
      ComisionTotal: json["ComisionTotal"],
      Direccion: json["Direccion"]
  );

  Map<String, dynamic> toJson() => {
    "id_Carrito": id_Carrito,
    "id_Usuario": id_Usuario,
    "PrecioCarrito": PrecioCarrito,
    "CantidadRest": CantidadRest,
    "ComisionTotal": ComisionTotal,
    "Direccion": Direccion
  };
}