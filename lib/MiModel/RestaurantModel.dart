class RestaurantModel {
  int id_Restaurant;
  String Nombre;
  String Descripcion;
  int TipoCategoria;
  int TipoRestaurant;
  String Telefono;
  String Domicilio;
  int Sector;
  String DiasLaborales;
  String TipoServ;
  String horario;
  String Activo;
  String logo;
  DateTime FechaReg;
  double Latitud;
  double Longitud;

  RestaurantModel({
    this.id_Restaurant,
    this.Nombre,
    this.Descripcion,
    this.TipoCategoria,
    this.TipoRestaurant,
    this.Telefono,
    this.Domicilio,
    this.Sector,
    this.DiasLaborales,
    this.TipoServ,
    this.horario,
    this.Activo,
    this.logo,
    this.FechaReg,
    this.Latitud,
    this.Longitud
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
    id_Restaurant: json["id_Restaurant"],
    Nombre: json["Nombre"],
    Descripcion: json["Descripcion"],
    TipoCategoria: json["TipoCategoria"],
    TipoRestaurant: json["TipoRestaurant"],
    Telefono: json["Telefono"],
    Domicilio: json["Domicilio"],
    Sector: json["Sector"],
    DiasLaborales: json["DiasLaborales"],
    TipoServ: json["TipoServ"],
    horario: json["horario"],
    Activo: json["Activo"],
    logo: json["logo"],
    FechaReg: DateTime.parse(json["FechaReg"]),
    Latitud: json["latitud"],
    Longitud: json["longitud"],
  );

  Map<String, dynamic> toJson() => {
    "id_Restaurant": id_Restaurant,
    "Nombre": Nombre,
    "Descripcion": Descripcion,
    "TipoCategoria": TipoCategoria.toInt(),
    "TipoRestaurant": TipoRestaurant.toInt(),
    "Telefono": Telefono,
    "Domicilio": Domicilio,
    "Sector": Sector.toInt(),
    "DiasLaborales": DiasLaborales,
    "TipoServ": TipoServ,
    "horario": horario,
    "Activo": Activo,
    "logo": logo,
    "FechaReg": FechaReg.toIso8601String(),
    "Latitud": Latitud.toDouble(),
    "Longitud": Longitud.toDouble(),
  };
}

class ValCampoRestaurante{
  bool Nombre;
  bool Descripcion;
  bool TipoCategoria;
  bool TipoRestaurant;
  bool Telefono;
  bool Domicilio;
  bool Sector;
  bool DiasLaborales;
  bool TipoServ;
  bool horario1;
  bool horario2;
  bool AM;
  bool PM;
  bool logo;
  bool Ubica;

  ValCampoRestaurante({
    this.Nombre,
    this.Descripcion,
    this.TipoCategoria,
    this.TipoRestaurant,
    this.Telefono,
    this.Domicilio,
    this.Sector,
    this.DiasLaborales,
    this.TipoServ,
    this.horario1,
    this.horario2,
    this.AM,
    this.PM,
    this.logo,
    this.Ubica
  });

  void IniciaCampos(){
    Nombre = false;
    Descripcion = false;
    TipoCategoria = false;
    TipoRestaurant = false;
    Telefono = false;
    Domicilio = false;
    Sector = false;
    DiasLaborales = false;
    TipoServ = false;
    horario1 = false;
    horario2 = false;
    AM = false;
    PM = false;
    logo = false;
    Ubica = false;
  }
}