class TraeInfoXcpModel {
  int id_localidad;
  int id_Estados;
  String NombreEstado;
  String Nombre_municipio;
  String cve_municipio_cp;
  String Nombre_Colonia;
  String cve_colonia;
  String cve_Corta;

  TraeInfoXcpModel({this.id_localidad,
                    this.id_Estados,
                    this.NombreEstado,
                    this.Nombre_municipio,
                    this.cve_municipio_cp,
                    this.Nombre_Colonia,
                    this.cve_colonia,
                    this.cve_Corta});

  factory TraeInfoXcpModel.fromJson(Map<String, dynamic> json) => TraeInfoXcpModel(
    id_localidad: json["id_localidad"],
    id_Estados: json["id_Estados"],
    NombreEstado: json["NombreEstado"],
    Nombre_municipio: json["Nombre_municipio"],
    cve_municipio_cp: json["cve_municipio_cp"],
    Nombre_Colonia: json["Nombre_Colonia"],
    cve_colonia: json["cve_colonia"],
    cve_Corta: json["cve_Corta"]
  );

  Map<String, dynamic> toJson() => {
    "id_localidad": id_localidad,
    "id_Estados": id_Estados,
    "NombreEstado": NombreEstado,
    "Nombre_municipio": Nombre_municipio,
    "cve_municipio_cp": cve_municipio_cp,
    "Nombre_Colonia": Nombre_Colonia,
    "cve_colonia": cve_colonia,
    "cve_Corta": cve_Corta
  };
}
