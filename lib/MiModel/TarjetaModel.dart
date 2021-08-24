class TarjetaModel {
  int id_Tarjeta;
  int id_Usuario;
  String NoTarjeta;
  String Nombre;
  String Alias;
  String MesVen;
  String AnoVen;
  String CodSeg;
  int TipoUsuario;
  String Estatus;
  bool EsDefault;

  TarjetaModel({this.id_Tarjeta,
                this.id_Usuario,
                this.NoTarjeta,
                this.Nombre,
                this.Alias,
                this.MesVen,
                this.AnoVen,
                this.CodSeg,
                this.TipoUsuario,
                this.Estatus,
                this.EsDefault});

  factory TarjetaModel.fromJson(Map<String, dynamic> json) => TarjetaModel(
      id_Tarjeta: json["id_Tarjeta"],
      id_Usuario: json["id_Usuario"],
      NoTarjeta: json["NoTarjeta"],
      Nombre: json["Nombre"],
      Alias: json["Alias"],
      MesVen: json["MesVen"],
      AnoVen: json["AnoVen"],
      CodSeg: json["CodSeg"],
      TipoUsuario: json["TipoUsuario"],
      Estatus: json["Estatus"],
      EsDefault: json["EsDefault"]
  );

  Map<String, dynamic> toJson() => {
    "id_Tarjeta": id_Tarjeta,
    "id_Usuario": id_Usuario,
    "NoTarjeta": NoTarjeta,
    "Nombre": Nombre,
    "Alias": Alias,
    "MesVen": MesVen,
    "AnoVen": AnoVen,
    "CodSeg": CodSeg,
    "TipoUsuario": TipoUsuario,
    "Estatus": Estatus,
    "EsDefault": EsDefault
  };
}
