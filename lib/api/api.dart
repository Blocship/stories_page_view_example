import '../model/story.dart';

Future<List<Story>> getStoryData() async {
  final List<Story> storiesData = [];
  await Future.delayed(const Duration(seconds: 5));
  storiesData.add(
    Story.fromJson({
      "data": "Story 1",
      "snaps": [
        {
          "type": "text",
          "data": "Hello World",
          "duration": "5",
        },
        {
          "type": "image",
          "data":
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
          "duration": "5"
        },
        {
          "type": "video",
          "data":
              "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
          "duration": "10"
        },
      ],
    }),
  );
  storiesData.add(
    Story.fromJson({
      "data": "Story 2",
      "snaps": [
        {
          "type": "image",
          "data":
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
          "duration": "5"
        },
        {
          "type": "text",
          "data": "Hello World 2",
          "duration": "5",
        },
      ],
    }),
  );
  storiesData.add(
    Story.fromJson({
      "data": "Story 3",
      "snaps": [
        {
          "type": "video",
          "data":
              "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
          "duration": "10"
        },
      ],
    }),
  );
  return storiesData;
}
