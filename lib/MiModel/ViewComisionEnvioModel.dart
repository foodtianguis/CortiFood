class ViewComisionEnvioModel {
  int id_ColoniaRestaurant;
  int id_localidad;
  int id_Restaurant;
  String Nombre_Colonia;
  String cve_municipio_cp;
  int id_ConfiguracionComision;
  String cve_Zona;
  int id_ComisionEnvio;
  int TipoComision;
  double Comision;
  double ComisionApp;
  String Descripcion;

  ViewComisionEnvioModel({
    this.id_ColoniaRestaurant,
    this.id_localidad,
    this.id_Restaurant,
    this.Nombre_Colonia,
    this.cve_municipio_cp,
    this.id_ConfiguracionComision,
    this.cve_Zona,
    this.id_ComisionEnvio,
    this.TipoComision,
    this.Comision,
    this.ComisionApp,
    this.Descripcion,
  });

  factory ViewComisionEnvioModel.fromJson(Map<String, dynamic> json) =>
      ViewComisionEnvioModel(
          id_ColoniaRestaurant: json["id_ColoniaRestaurant"],
          id_localidad: json["id_localidad"],
          id_Restaurant: json["id_Restaurant"],
          Nombre_Colonia: json["Nombre_Colonia"],
          cve_municipio_cp: json["cve_municipio_cp"],
          id_ConfiguracionComision: json["id_ConfiguracionComision"],
          cve_Zona: json["cve_Zona"],
          id_ComisionEnvio: json["id_ComisionEnvio"],
          TipoComision: json["TipoComision"],
          Comision: json["Comision"],
          ComisionApp: json["ComisionApp"],
          Descripcion: json["Descripcion"]);

  Map<String, dynamic> toJson() => {
        "id_ColoniaRestaurant": id_ColoniaRestaurant,
        "id_localidad": id_localidad,
        "id_Restaurant": id_Restaurant,
        "Nombre_Colonia": Nombre_Colonia,
        "cve_municipio_cp": cve_municipio_cp,
        "id_ConfiguracionComision": id_ConfiguracionComision,
        "cve_Zona": cve_Zona,
        "id_ComisionEnvio": id_ComisionEnvio,
        "TipoComision": TipoComision,
        "Comision": Comision,
        "ComisionApp": ComisionApp,
        "Descripcion": Descripcion
      };
}
