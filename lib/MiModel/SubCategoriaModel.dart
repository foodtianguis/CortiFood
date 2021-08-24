class SubCategoriaModel {
  int id_SubCategoria;
  String SubCatNombre;
  String Codigo;
  String SubCatIcon;

  SubCategoriaModel({this.id_SubCategoria,this.SubCatNombre,this.Codigo,this.SubCatIcon});

  factory SubCategoriaModel.fromJson(Map<String, dynamic> json) => SubCategoriaModel(
    id_SubCategoria: json["id_SubCategoria"],
    SubCatNombre: json["SubCatNombre"],
    Codigo: json["Codigo"],
    SubCatIcon: json["SubCatIcon"],
  );

  Map<String, dynamic> toJson() => {
    "id_SubCategoria": id_SubCategoria,
    "SubCatNombre": SubCatNombre,
    "Codigo": Codigo,
    "SubCatIcon": SubCatIcon,
  };
}
