class PhotoModel {
  PhotoModel({
    required this.photoUrl,
    required this.title,
    required this.description,
  });

  final String photoUrl;
  final String title;
  final String description;

  String getPhotoUrl() {
    //return '$photoUrl?w=$width&h=$height&fit=crop';
    return "$photoUrl/500/500";
  }
}
