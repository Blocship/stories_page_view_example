import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';

import '../model/snap.dart';
import 'image_snap.dart';
import 'video_snap.dart';
import 'widget_snap.dart';

abstract class SnapView extends Widget {
  const SnapView({
    Key? key,
    required this.controller,
    required this.snap,
  }) : super(key: key);

  final StoryController controller;
  final Snap snap;

  factory SnapView.fromSnap({
    required StoryController controller,
    required Snap snap,
  }) {
    return switch (snap.type) {
      SnapType.image => ImageSnap(
          controller: controller,
          snap: snap,
        ),
      SnapType.video => VideoSnap(
          controller: controller,
          snap: snap,
        ),
      SnapType.text => WidgetSnap(
          controller: controller,
          snap: snap,
        )
    };
  }
}
