import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
// import 'package:voice/common/fonts/icons.dart';
import 'package:voice/components/video/VideoSideBarInfo.dart';

class VideoAction extends StatefulWidget {
  final vedioData;
  VideoAction({Key key, this.vedioData}) : super(key: key);
  _VideoActionState createState() => _VideoActionState();
}

class _VideoActionState extends State<VideoAction> {
  VideoPlayerController videoController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    initVideo();
  }

  /// 初始化Video
  void initVideo() {
    if (videoController != null && chewieController != null) {
      videoController = null;
      chewieController = null;
    }
    videoController = VideoPlayerController.network(widget.vedioData['url']);
    chewieController = ChewieController(
      videoPlayerController: videoController,
      aspectRatio: 3 / 2, //宽高比
      autoPlay: true, //是否自动播放
      looping: true, //是否循环播放
      showControls: false, //控制底部控制条是否显示
      placeholder: Container(color: Colors.grey[200]), //占位图
    );
  }

  /// 当页面销毁的时候，视频控制器也需要被消耗毁，防止内存泄露。
  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
            top: 0,
            left: 0,
            child: Container(
                width: screenWidth,
                height: screenHeight,
                child: Center(child: Chewie(controller: chewieController)))),
        Positioned(
            bottom: 80,
            left: 0,
            child: Container(
                width: screenWidth,
                // height: 100,
                padding: EdgeInsets.only(left: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('@' + widget.vedioData['author'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 4),
                      Text(widget.vedioData['description'],
                          style: TextStyle(fontSize: 14, color: Colors.white))
                    ]))),
        VideoSideBarInfo(vedioInfoData: widget.vedioData)
      ],
    );
  }
}
