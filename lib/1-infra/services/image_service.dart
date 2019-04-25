import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dod/2-business/models/image_model.dart';
import 'package:dod/2-business/models/image_result_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:core';

class ImageService {
  Dio _dio;

  ImageService() {
    _dio = Dio();
  }

  Future<ImageResultModel> analize(ImageModel image) async {
    try {
      Response response = await _dio.post("https://tv.dodvision.com/test-app/",
          data: image.toJson());

      if (response.statusCode == 200) {
        return ImageResultModel.fromJson(response.data);
      } else {
        throw Exception("Something is wrong.");
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  var _downloadProgress = BehaviorSubject<int>.seeded(0);

  Observable<int> get downloadProgress => _downloadProgress.stream;

  Future<File> download(ImageResultModel image) async {
    try {
      var directory = await getApplicationDocumentsDirectory();

      String path = "${directory.path}/${image.emissora.finalImage}";

      await Directory("${directory.path}/media").create();
      // _downloadProgress.add(0);
      await _dio.download(
          "https://tv.dodvision.com/${image.emissora.finalImage}", path,
          onReceiveProgress: (parcial, total) {
        int value = (parcial / total * 100).ceil();
        _downloadProgress.add(value);
      });

      _downloadProgress.add(0);
      return File(path);
    } on DioError catch (e) {
      print(e);
      print(e.error);
      print(e.message);
      print(e.response?.data ?? "");
      return null;
    }
  }
}
