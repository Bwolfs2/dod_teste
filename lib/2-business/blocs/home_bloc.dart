import 'dart:io';

import 'package:dod/1-infra/services/image_service.dart';
import 'package:dod/2-business/models/image_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  ImageService imageService;

  HomeBloc() {
    imageService = ImageService();
  }

  var _controllerLoading = BehaviorSubject<bool>();
  Observable<bool> get loading => _controllerLoading.stream;

  var _controllerProgress = BehaviorSubject<int>();
  Observable<int> get downloadProgress => _controllerProgress.stream;

  var _controllerFile = BehaviorSubject<File>();
  Observable<File> get fileStream => _controllerFile.stream;

  Future getImage() async {
    try {
      _controllerProgress.add(null);
      var file = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 1000, maxHeight: 1000);

      _controllerFile.add(file);

      _controllerLoading.add(true);

      var imageResult = await imageService.analize(ImageModel.fromFile(file));

      imageService.downloadProgress
          .listen((progress) => _controllerProgress.add(progress));

      File image = await imageService.download(imageResult);

      _controllerFile.add(image);
    } catch (e) {
      print(e);
    } finally {
      _controllerLoading.add(false);
    }
  }

  void dispose() {
    _controllerLoading.close();
    _controllerFile.close();
    _controllerProgress.close();
  }
}
