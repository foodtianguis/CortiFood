class Publicidad {
  int id_Publicidad;
  int id_menu;
  String NombrePub;
  String DescripPub;
  double CostoPub;
  String ActivoPub;
  int PrioridadPub;
  int DuracionPub;
  String ImagenPub;
  String FechaIniPub;
  String FechaFinPub;

  Publicidad(
      {this.id_Publicidad,
        this.id_menu,
        this.NombrePub,
        this.DescripPub,
        this.CostoPub,
        this.ActivoPub,
        this.PrioridadPub,
        this.DuracionPub,
        this.ImagenPub,
        this.FechaIniPub,
        this.FechaFinPub});

  factory Publicidad.fromJson(Map<String, dynamic> json) => Publicidad(
    id_Publicidad: json["id_Publicidad"],
    id_menu: json["id_menu"],
    NombrePub: json["NombrePub"],
    DescripPub: json["DescripPub"],
    CostoPub: json["CostoPub"],
    ActivoPub: json["ActivoPub"],
    PrioridadPub: json["PrioridadPub"],
    DuracionPub: json["DuracionPub"],
    ImagenPub: json["ImagenPub"],
    FechaIniPub: json["FechaIniPub"],
    FechaFinPub: json["FechaFinPub"],
  );

  Map<String, dynamic> toJson() => {
    "id_Publicidad": id_Publicidad,
    "id_menu": id_menu,
    "NombrePub": NombrePub,
    "DescripPub": DescripPub,
    "CostoPub": CostoPub,
    "ActivoPub": ActivoPub,
    "PrioridadPub": PrioridadPub,
    "DuracionPub": DuracionPub,
    "ImagenPub": ImagenPub,
    "FechaIniPub": FechaIniPub,
    "FechaFinPub": FechaFinPub,
  };
}