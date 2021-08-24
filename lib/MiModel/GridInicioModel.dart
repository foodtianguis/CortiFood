class GridInicioModel {
  int id_menu;
  String Nombre;
  String Descripcion;
  double Precio;
  String foto;
  int id_restaurant;
  String NombreRestaurante;
  bool EmpresaActiva;

  GridInicioModel({this.id_menu,
    this.Nombre,
    this.Descripcion,
    this.Precio,
    this.foto,
    this.id_restaurant,
    this.NombreRestaurante,
    this.EmpresaActiva});

  factory GridInicioModel.fromJson(Map<String, dynamic> json) => GridInicioModel(
      id_menu: json["id_menu"],
      Nombre: json["Nombre"],
      Descripcion: json["Descripcion"],
      Precio: json["Precio"],
      foto: json["foto"],
      id_restaurant: json["id_restaurant"],
      NombreRestaurante: json["NombreRestaurante"],
      EmpresaActiva: json["EmpresaActiva"]
  );

  Map<String, dynamic> toJson() => {
    "id_menu": id_menu,
    "Nombre": Nombre,
    "Descripcion": Descripcion,
    "Precio": Precio,
    "foto": foto,
    "id_restaurant": id_restaurant,
    "NombreRestaurante": NombreRestaurante,
    "EmpresaActiva": EmpresaActiva
  };
}
