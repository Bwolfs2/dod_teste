import 'dart:convert';
import 'dart:io';

class ImageModel {
  String image;

  ImageModel({this.image});

  factory ImageModel.fromFile(File file) => ImageModel(
        image: base64Encode(file.readAsBytesSync()),
      );

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
