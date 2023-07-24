import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';
import 'package:stories_page_view_example/api/api.dart';

import 'model/story.dart';
import 'view/progress_bar.dart';
import 'view/snap_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const StoriesPage(index: 0),
              ),
            );
          },
          child: const Text("Go to Sukuk Stories"),
        ),
      ),
    );
  }
}

class StoriesPage extends StatefulWidget {
  final int index;
  const StoriesPage({
    super.key,
    required this.index,
  });

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  List<Story> storiesData = [];

  Future<void> getData() async {
    storiesData = await getStoryData();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget getChild(
    int storyPageIndex,
    int snapIndex,
    StoryController controller,
  ) {
    final snap = storiesData[storyPageIndex].snaps[snapIndex];
    return SnapView.fromSnap(controller: controller, snap: snap);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (storiesData.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: StoryPageView(
        pageCount: storiesData.length,
        outOfRangeCompleted: () {
          Navigator.of(context).pop();
        },
        durationBuilder: (pageIndex, snapIndex) {
          return storiesData[pageIndex].snaps[snapIndex].duration;
        },
        snapCountBuilder: (pageIndex) {
          return storiesData[pageIndex].snaps.length;
        },
        snapInitialIndexBuilder: (pageIndex) {
          return 0;
        },
        itemBuilder: (context, pageIndex, snapIndex, animation, controller) {
          return Stack(
            children: [
              Scaffold(
                body: getChild(
                  pageIndex,
                  snapIndex,
                  controller,
                ),
              ),
              SafeArea(
                child: StoryProgressBars(
                  snapIndex: snapIndex,
                  snapCount: storiesData[pageIndex].snaps.length,
                  animation: animation,
                  builder: (progress) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        child: ProgressBarIndicator(
                          progress: progress,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
