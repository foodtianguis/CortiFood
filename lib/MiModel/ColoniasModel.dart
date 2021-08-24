class ColoniasModel{
  int id_localidad;
  int id_Estados;
  String Nombre_municipio;
  String cve_municipio_cp;
  String Nombre_Colonia;
  String cve_Zona;
  int cve_Consecutivo;

  ColoniasModel({
    this.id_localidad,
    this.id_Estados,
    this.Nombre_municipio,
    this.cve_municipio_cp,
    this.Nombre_Colonia,
    this.cve_Zona,
    this.cve_Consecutivo,
  });

  factory ColoniasModel.fromJson(Map<String, dynamic> json) => ColoniasModel(
      id_localidad: json["id_localidad"],
      id_Estados: json["id_Estados"],
      Nombre_municipio: json["Nombre_municipio"],
      cve_municipio_cp: json["cve_municipio_cp"],
      Nombre_Colonia: json["Nombre_Colonia"],
      cve_Zona: json["cve_Zona"],
      cve_Consecutivo: json["cve_Consecutivo"]
  );

  Map<String, dynamic> toJson() => {
    "id_localidad": id_localidad,
    "id_Estados": id_Estados,
    "Nombre_municipio": Nombre_municipio,
    "cve_municipio_cp": cve_municipio_cp,
    "Nombre_Colonia": Nombre_Colonia,
    "cve_Zona": cve_Zona,
    "cve_Consecutivo": cve_Consecutivo
  };
}