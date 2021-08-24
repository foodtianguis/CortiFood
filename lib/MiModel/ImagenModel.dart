class ImagenModel {
  String foto;

  ImagenModel({
    this.foto
  });

  factory ImagenModel.fromJson(Map<String, dynamic> json) => ImagenModel(
    foto: json["foto"]
  );

  Map<String, dynamic> toJson() => {
    "foto": foto,
  };
}