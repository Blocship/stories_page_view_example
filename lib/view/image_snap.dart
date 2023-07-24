import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';

import '../model/snap.dart';
import 'snap_view.dart';

class ImageSnap extends StatelessWidget implements SnapView {
  @override
  final StoryController controller;
  @override
  final Snap snap;

  const ImageSnap({
    super.key,
    required this.controller,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Image.network(
        snap.data,
        fit: BoxFit.fitWidth,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame != null) {
            controller.play();
          }
          return child;
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress != null) {
            controller.pause();
          }
          if (loadingProgress == null) {
            return child;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.error),
          );
        },
      ),
    );
  }
}
