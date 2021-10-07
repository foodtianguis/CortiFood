class EncaCarritoModel{
  int id_Carrito;
  int id_Restaurant;
  String RestaurantNombre;
  int PlatillosDif;
  double Comision;
  int TotalPlatillos;
  double Total;

  EncaCarritoModel({
    this.id_Carrito,
    this.id_Restaurant,
    this.RestaurantNombre,
    this.Comision,
    this.PlatillosDif,
    this.TotalPlatillos,
    this.Total,
  });

  factory EncaCarritoModel.fromJson(Map<String, dynamic> json) => EncaCarritoModel(
      id_Carrito: json["id_Carrito"],
      id_Restaurant: json["id_Restaurant"],
      RestaurantNombre: json["RestaurantNombre"],
      Comision: json["Comision"],
      PlatillosDif: json["PlatillosDif"],
      TotalPlatillos: json["TotalPlatillos"],
      Total: json["Total"]
  );

  Map<String, dynamic> toJson() => {
    "id_Carrito": id_Carrito,
    "id_Restaurant": id_Restaurant,
    "RestaurantNombre": RestaurantNombre,
    "Comision": Comision,
    "PlatillosDif": PlatillosDif,
    "TotalPlatillos": TotalPlatillos,
    "Total": Total
  };
}