class UbicacionModel {
  String Ubicacion;
  String UbicacionCP;
  String Colonia;
  double Latitud;
  double Longitud;

  UbicacionModel(
      {this.Ubicacion,
      this.UbicacionCP,
      this.Colonia,
      this.Latitud,
      this.Longitud});

  factory UbicacionModel.fromJson(Map<String, dynamic> json) => UbicacionModel(
      Ubicacion: json["Ubicacion"],
      UbicacionCP: json["UbicacionCP"],
      Colonia: json["Colonia"],
      Latitud: json["Latitud"],
      Longitud: json["Longitud"]);

  Map<String, dynamic> toJson() => {
        "Ubicacion": Ubicacion,
        "UbicacionCP": UbicacionCP,
        "Colonia": Colonia,
        "Latitud": Latitud,
        "Longitud": Longitud
      };
}
