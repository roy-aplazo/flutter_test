import 'package:flutter/material.dart';
import 'package:tech_week_demo/features/list_example/data/unsplash_service.dart';
import 'package:tech_week_demo/features/list_example/models/photo_model.dart';
import 'package:tech_week_demo/features/list_example/widgets/photo_list_item.dart';

class PhotoList extends StatefulWidget {
  const PhotoList({super.key, required this.photoModels});

  final List<PhotoModel> photoModels;

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final UnsplashService unsplashService = UnsplashService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...widget.photoModels.map(
            (photoModel) => PhotoListItem(photoModel: photoModel),
          ),
        ],
      ),
    );
  }
}
