class ComisionEnvioModel {
  int id_ComisionEnvio;
  int TipoComision;
  double Comision;
  double ComisionApp;
  String Descripcion;

  ComisionEnvioModel(
      {this.id_ComisionEnvio,
      this.TipoComision,
      this.Comision,
      this.ComisionApp,
      this.Descripcion});

  factory ComisionEnvioModel.fromJson(Map<String, dynamic> json) =>
      ComisionEnvioModel(
          id_ComisionEnvio: json["id_ComisionEnvio"],
          TipoComision: json["TipoComision"],
          Comision: json["Comision"],
          ComisionApp: json["ComisionApp"],
          Descripcion: json["Descripcion"]);

  Map<String, dynamic> toJson() => {
        "id_ComisionEnvio": id_ComisionEnvio,
        "TipoComision": TipoComision,
        "Comision": Comision,
        "ComisionApp": ComisionApp,
        "Descripcion": Descripcion
      };
}
