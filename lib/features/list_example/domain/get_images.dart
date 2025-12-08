import 'package:tech_week_demo/features/list_example/data/list_data.dart';
import 'package:tech_week_demo/features/list_example/data/unsplash_service.dart';
import 'package:tech_week_demo/features/list_example/models/photo_model.dart';

class GetImages {
  final UnsplashService unsplashService = UnsplashService();

  Future<List<PhotoModel>> call() async {
    return await _getImagesLocal();
  }

  Future<List<PhotoModel>> _getImagesLocal() async {
    return ListData.photoModels;
  }

  Future<List<PhotoModel>> _getImagesRemote() async {
    return await unsplashService.getRandomPhotos();
  }
}
