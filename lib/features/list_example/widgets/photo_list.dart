import 'package:flutter/material.dart';
import 'package:tech_week_demo/features/list_example/data/unsplash_service.dart';
import 'package:tech_week_demo/features/list_example/models/photo_model.dart';
import 'package:tech_week_demo/features/list_example/widgets/photo_list_item.dart';

class PhotoList extends StatefulWidget {
  const PhotoList({
    super.key,
    required this.photoModels,
    required this.scrollController,
  });

  final List<PhotoModel> photoModels;
  final ScrollController scrollController;

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final UnsplashService unsplashService = UnsplashService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            const SizedBox(height: 8),
            ...widget.photoModels.map(
              (photoModel) => PhotoListItem(photoModel: photoModel),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      //child: ListView.builder(
      //  controller: widget.scrollController,
      //  padding: const EdgeInsets.all(8),
      //  itemCount: widget.photoModels.length,
      //  itemBuilder: (context, index) =>
      //      PhotoListItem(photoModel: widget.photoModels[index]),
      //),
    );
  }
}
