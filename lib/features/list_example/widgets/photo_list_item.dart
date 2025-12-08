import 'package:flutter/material.dart';
import 'package:tech_week_demo/features/list_example/models/photo_model.dart';

class PhotoListItem extends StatelessWidget {
  const PhotoListItem({super.key, required this.photoModel});

  final PhotoModel photoModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(photoModel.getPhotoUrl()),
          Text(photoModel.title),
          Text(photoModel.description),
        ],
      ),
    );
  }
}
