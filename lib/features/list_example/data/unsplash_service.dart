import 'package:dio/dio.dart';
import 'package:tech_week_demo/features/list_example/models/photo_model.dart';

class UnsplashService {
  final Dio _dio = Dio();

  // IMPORTANTE: Reemplaza con tu Access Key de Unsplash
  // Usa el "Access Key" que te dieron, NO el Secret Key
  static const String _accessKey =
      '7MkIdPBgAXhU20IlNjA7KK1ORtl1jf99kQsb3bTevhI';
  static const String _baseUrl = 'https://api.unsplash.com';

  // El API de Unsplash permite máximo 30 fotos por request
  static const int _maxPhotosPerRequest = 30;

  Future<List<PhotoModel>> getRandomPhotos() async {
    return _getRandomPhotos(count: 500, width: 500, height: 500);
  }

  Future<List<PhotoModel>> _getRandomPhotos({
    int count = 1000,
    int width = 3000,
    int height = 3000,
  }) async {
    final List<PhotoModel> allPhotos = [];

    // Calcular cuántas páginas necesitamos (30 fotos por página)
    final int pagesNeeded = (count / _maxPhotosPerRequest).ceil();

    try {
      // Hacer requests en paralelo para ser más eficiente
      final List<Future<void>> requests = [];

      for (int page = 1; page <= pagesNeeded; page++) {
        requests.add(_fetchPhotosPage(page, width, height, allPhotos));
      }

      // Esperar a que todos los requests terminen
      await Future.wait(requests);

      // Limitar a la cantidad solicitada
      return allPhotos.take(count).toList();
    } catch (e) {
      throw Exception('Error al obtener fotos de Unsplash: $e');
    }
  }

  Future<void> _fetchPhotosPage(
    int page,
    int width,
    int height,
    List<PhotoModel> allPhotos,
  ) async {
    final response = await _dio.get(
      '$_baseUrl/photos',
      queryParameters: {
        'page': page,
        'per_page': _maxPhotosPerRequest,
        'client_id': _accessKey,
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> photos = response.data;

      for (var photo in photos) {
        allPhotos.add(_mapToPhotoModel(photo, width, height));
      }
    }
  }

  /// Convierte la respuesta del API a PhotoModel
  PhotoModel _mapToPhotoModel(
    Map<String, dynamic> photo,
    int width,
    int height,
  ) {
    final urls = photo['urls'] as Map<String, dynamic>?;
    final user = photo['user'] as Map<String, dynamic>?;
    final description = photo['description'] as String?;
    final altDescription = photo['alt_description'] as String?;

    // Construir URL con tamaño personalizado
    final String photoUrl = urls?['raw'] as String? ?? '';
    final String sizedUrl = '$photoUrl?w=$width&h=$height&fit=crop';

    // Usar description, alt_description o un valor por defecto
    final String photoDescription =
        description ?? altDescription ?? 'Foto de Unsplash';

    // Usar el nombre del autor como título
    final String authorName = user?['name'] as String? ?? 'Fotógrafo';
    final String title = 'Foto por $authorName';

    return PhotoModel(
      photoUrl: sizedUrl,
      title: title,
      description: photoDescription,
    );
  }
}
