class ComisionEnvioCompraModel {
  int id_localidad;
  int id_ConfiguracionComision;
  int id_Restaurant;
  int id_ComisionEnvio;
  double Comision;
  double ComisionApp;
  String Descripcion;

  ComisionEnvioCompraModel({
    this.id_localidad,
    this.id_Restaurant,
    this.id_ConfiguracionComision,
    this.id_ComisionEnvio,
    this.Comision,
    this.ComisionApp,
    this.Descripcion,
  });

  factory ComisionEnvioCompraModel.fromJson(Map<String, dynamic> json) =>
      ComisionEnvioCompraModel(
          id_localidad: json["id_localidad"],
          id_Restaurant: json["id_Restaurant"],
          id_ConfiguracionComision: json["id_ConfiguracionComision"],
          id_ComisionEnvio: json["id_ComisionEnvio"],
          Comision: json["Comision"],
          ComisionApp: json["ComisionApp"],
          Descripcion: json["Descripcion"]);

  Map<String, dynamic> toJson() => {
        "id_localidad": id_localidad,
        "id_Restaurant": id_Restaurant,
        "id_ConfiguracionComision": id_ConfiguracionComision,
        "id_ComisionEnvio": id_ComisionEnvio,
        "Comision": Comision,
        "ComisionApp": ComisionApp,
        "Descripcion": Descripcion
      };
}
