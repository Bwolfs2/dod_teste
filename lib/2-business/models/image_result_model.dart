class ImageResultModel {
  Emissora emissora;

  ImageResultModel({
    this.emissora,
  });

  factory ImageResultModel.fromJson(Map<String, dynamic> json) =>
      new ImageResultModel(
        emissora: Emissora.fromJson(json["emissora"]),
      );

  Map<String, dynamic> toJson() => {
        "emissora": emissora.toJson(),
      };
}

class Emissora {
  List<dynamic> pessoas;
  List<String> objects;
  String finalImage;

  Emissora({
    this.pessoas,
    this.objects,
    this.finalImage,
  });

  factory Emissora.fromJson(Map<String, dynamic> json) => new Emissora(
        pessoas: new List<dynamic>.from(json["pessoas"].map((x) => x)),
        objects: new List<String>.from(json["objects"].map((x) => x)),
        finalImage: json["final_image"],
      );

  Map<String, dynamic> toJson() => {
        "pessoas": new List<dynamic>.from(pessoas.map((x) => x)),
        "objects": new List<dynamic>.from(objects.map((x) => x)),
        "final_image": finalImage,
      };
}
