import 'package:flutter/material.dart';
import 'package:tech_week_demo/features/list_example/domain/get_images.dart';
import 'package:tech_week_demo/features/list_example/models/photo_model.dart';
import 'package:tech_week_demo/features/list_example/widgets/photo_list.dart';

class ListExampleScreen extends StatefulWidget {
  const ListExampleScreen({super.key});

  @override
  State<ListExampleScreen> createState() => _ListExampleScreenState();
}

class _ListExampleScreenState extends State<ListExampleScreen> {
  late GetImages getImages;
  final ScrollController scrollController = ScrollController();
  late Future<List<PhotoModel>> futurePhotos;
  bool _showScrollintToTopButton = false;

  @override
  void initState() {
    super.initState();
    getImages = GetImages();
    futurePhotos = getImages.call();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // bool showScrollintToTopButton = scrollController.offset > 100;
    // if (showScrollintToTopButton != _showScrollintToTopButton) {
    setState(() {
      _showScrollintToTopButton = scrollController.offset > 100;
      //     _showScrollintToTopButton = showScrollintToTopButton;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Example')),
      body: FutureBuilder(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return PhotoList(
            scrollController: scrollController,
            photoModels: snapshot.data ?? [],
          );
        },
      ),
      floatingActionButton: _showScrollintToTopButton
          ? FloatingActionButton(
              onPressed: () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : const SizedBox.shrink(),
    );
  }
}

class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showScrollintToTopButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    bool showScrollintToTopButton = widget.scrollController.offset > 100;
    if (showScrollintToTopButton != _showScrollintToTopButton) {
      setState(() {
        _showScrollintToTopButton = showScrollintToTopButton;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showScrollintToTopButton
        ? FloatingActionButton(
            onPressed: () {
              widget.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
          )
        : const SizedBox.shrink();
  }
}
