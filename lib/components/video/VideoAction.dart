import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:voice/components/video/VideoSideBarInfo.dart';
import 'package:voice/model/VideoModel.dart';

class VideoAction extends StatefulWidget {
  final VideoModel vedioData;
  final String type;
  final int index;
  VideoAction({Key key, this.vedioData, this.index, this.type})
      : super(key: key);
  _VideoActionState createState() => _VideoActionState();
}

class _VideoActionState extends State<VideoAction> {
  VideoPlayerController videoController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    print('intiState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChange');
    // initVideo();
  }

  /// 初始化Video
  void initVideo() {
    if (videoController != null && chewieController != null) {
      videoController = null;
      chewieController = null;
    }
    videoController = VideoPlayerController.network(widget.vedioData.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoController,
      aspectRatio: 3 / 2, //宽高比
      autoPlay: true, //是否自动播放
      looping: true, //是否循环播放
      showControls: false, //控制底部控制条是否显示
      placeholder: Container(
          child: Center(
              child: Text('正在加载...',
                  style: TextStyle(fontSize: 14, color: Colors.grey)))), //占位图
    );
  }

  /// 当页面销毁的时候，视频控制器也需要被消耗毁，防止内存泄露。
  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
    videoController?.dispose();
    chewieController?.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    videoController?.dispose();
    chewieController?.dispose();
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
            // child: Center(
            //   child: Chewie(
            //     controller: chewieController,
            //   ),
            // ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 0,
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.only(left: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('@' + widget.vedioData.userName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 4),
                  Text(widget.vedioData.videoDescription,
                      style: TextStyle(fontSize: 14, color: Colors.white))
                ]),
          ),
        ),
        VideoSideBarInfo(
          videoInfoData: widget.vedioData,
          type: widget.type,
          index: widget.index,
        )
      ],
    );
  }
}
