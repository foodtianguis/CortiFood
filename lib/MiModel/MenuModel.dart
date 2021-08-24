class MenuModel {
  int id_menu;
  int id_restaurant;
  String Nombre;
  String Descripcion;
  int TipoCategoria;
  double Precio;
  String Extras;
  String Activo;
  String foto;
  String FechaReg;

  MenuModel({this.id_menu,
        this.id_restaurant,
        this.Nombre,
        this.Descripcion,
        this.TipoCategoria,
        this.Precio,
        this.Extras,
        this.Activo,
        this.foto,
        this.FechaReg});

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    id_menu: json["id_menu"],
    id_restaurant: json["id_restaurant"],
    Nombre: json["Nombre"],
    Descripcion: json["Descripcion"],
    TipoCategoria: json["TipoCategoria"],
    Precio: json["Precio"],
    Extras: json["Extras"],
    Activo: json["Activo"],
    foto: json["foto"],
    FechaReg: json["FechaReg"],
  );

  Map<String, dynamic> toJson() => {
    "id_menu": id_menu,
    "id_restaurant": id_restaurant,
    "Nombre": Nombre,
    "Descripcion": Descripcion,
    "TipoCategoria": TipoCategoria,
    "Precio": Precio,
    "Extras": Extras,
    "Activo": Activo,
    "foto": foto,
    "FechaReg": FechaReg,
  };
}

class ValCampoMenu{
  bool Nombre;
  bool Descripcion;
  bool TipoCategoria;
  bool Precio;
  bool Extras;
  bool foto;

  ValCampoMenu({
    this.Nombre,
    this.Descripcion,
    this.TipoCategoria,
    this.Precio,
    this.Extras,
    this.foto,
  });

  void IniciaCampos(){
    Nombre = false;
    Descripcion = false;
    TipoCategoria = false;
    Precio = false;
    Extras = false;
    foto = false;
  }
}