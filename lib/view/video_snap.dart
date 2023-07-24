import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';
import 'package:video_player/video_player.dart';

import '../model/snap.dart';
import 'snap_view.dart';

class VideoSnap extends StatefulWidget implements SnapView {
  @override
  final StoryController controller;
  @override
  final Snap snap;

  const VideoSnap({
    super.key,
    required this.controller,
    required this.snap,
  });

  @override
  State<VideoSnap> createState() => _VideoSnapState();
}

class _VideoSnapState extends State<VideoSnap> {
  late final VideoPlayerController _videoController;
  late final StreamSubscription<PlayBackState> playBackStateStreamSubscription;
  final ObservableObject<bool> isVideoPlayerStartedPlaying$ =
      false.asObservable();

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.snap.data));
    _videoController.initialize().then((value) {
      setState(() {});
    });
    _videoController.addListener(_onVideoControllerChange);
    _videoController.play();
    isVideoPlayerStartedPlaying$
        .attachListener(_onVideoPlayerStartedPlayingChange);
    playBackStateStreamSubscription =
        widget.controller.playBackStateStream.listen(_onPlayBackStateChange);
  }

  void _onVideoControllerChange() {
    final value = _videoController.value;
    final state = value.position > Duration.zero;
    isVideoPlayerStartedPlaying$.value = state;
  }

  void _onVideoPlayerStartedPlayingChange(bool oldValue, bool newValue) {
    bool isVideoPlayerStartedPlayingStarted =
        oldValue == false && newValue == true;
    if (isVideoPlayerStartedPlayingStarted) {
      widget.controller.play();
    }
  }

  void _onPlayBackStateChange(PlayBackState state) {
    switch (state) {
      case PlayBackState.playing:
        _videoController.play();
        break;
      case PlayBackState.paused:
        _videoController.pause();
        break;
      case PlayBackState.completed:
        _videoController.seekTo(Duration.zero);
        _videoController.pause();
        break;
      case PlayBackState.notStarted:
        break;
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    isVideoPlayerStartedPlaying$.detachListener();
    playBackStateStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      ),
    );
  }
}

/// Makes an object observable
/// calls the listener when the value changes and passes the old and new value
class ObservableObject<T> {
  T _value;
  void Function(T oldValue, T newValue)? _onChange;

  ObservableObject({
    required T value,
    void Function(T oldValue, T newValue)? didSet,
  })  : _value = value,
        _onChange = didSet;

  T get value => _value;

  set value(T newValue) {
    final oldValue = _value;
    _value = newValue;
    _onChange?.call(oldValue, newValue);
  }

  void attachListener(void Function(T oldValue, T newValue) listener) {
    assert(_onChange == null, "onChange can be initialized only once");
    _onChange = listener;
  }

  void detachListener() {
    _onChange = null;
  }
}

extension XObject on Object {
  ObservableObject<T> asObservable<T>({
    void Function(T oldValue, T newValue)? didSet,
  }) {
    return ObservableObject<T>(
      value: this as T,
      didSet: didSet,
    );
  }
}
