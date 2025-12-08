import 'package:flutter/material.dart';
import 'package:tech_week_demo/features/list_example/domain/get_images.dart';
import 'package:tech_week_demo/features/list_example/widgets/photo_list.dart';

class ListExampleScreen extends StatefulWidget {
  const ListExampleScreen({super.key});

  @override
  State<ListExampleScreen> createState() => _ListExampleScreenState();
}

class _ListExampleScreenState extends State<ListExampleScreen> {
  final GetImages getImages = GetImages();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Example')),
      body: FutureBuilder(
        future: getImages.call(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return PhotoList(photoModels: snapshot.data ?? []);
        },
      ),
    );
  }
}
