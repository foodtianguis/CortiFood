class InfoAdeudoXRestaurantModel {
  int CantPedidos;
  int CantPlatillos;
  String Nombre;
  double ComisionTotal;
  String Periodo;

  InfoAdeudoXRestaurantModel({
    this.CantPedidos,
    this.CantPlatillos,
    this.Nombre,
    this.ComisionTotal,
    this.Periodo,
  });

  factory InfoAdeudoXRestaurantModel.fromJson(Map<String, dynamic> json) =>
      InfoAdeudoXRestaurantModel(
          CantPedidos: json["CantPedidos"],
          CantPlatillos: json["CantPlatillos"],
          Nombre: json["Nombre"],
          ComisionTotal: json["ComisionTotal"],
          Periodo: json["Periodo"]);

  Map<String, dynamic> toJson() => {
        "CantPedidos": CantPedidos,
        "CantPlatillos": CantPlatillos,
        "Nombre": Nombre,
        "ComisionTotal": ComisionTotal,
        "Periodo": Periodo
      };
}
