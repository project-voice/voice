import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:voice/components/video/VideoSideBarInfo.dart';
import 'package:voice/model/VideoModel.dart';

class VideoAction extends StatefulWidget {
  final VideoModel vedioData;
  final String type;
  final int index;
  VideoAction({Key key, this.vedioData, this.index, this.type})
      : super(key: key);
  VideoActionState createState() => VideoActionState();
}

class VideoActionState extends State<VideoAction> {
  VideoPlayerController _videoController;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    print('initState');
    initVideo();
  }

  /// 初始化Video
  void initVideo() {
    _videoController = VideoPlayerController.network(widget.vedioData.videoUrl)
      ..setLooping(true)
      ..initialize().then((value) {
        setState(() {});
      });
    if (widget.index == 0) {
      _videoController.play();
    }
  }

  /// 当页面销毁的时候，视频控制器也需要被消耗毁，防止内存泄露。
  @override
  void deactivate() {
    super.deactivate();
    _videoController?.pause();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  play() {
    if (_videoController != null && !_videoController.value.isPlaying) {
      _videoController?.play();
    }
  }

  pause() {
    if (_videoController != null && _videoController.value.isPlaying) {
      _videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          top: -80,
          left: 0,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: _videoController.value.initialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : CircularProgressIndicator(),
            ),
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
        // 侧边信息栏
        VideoSideBarInfo(
          videoInfoData: widget.vedioData,
          type: widget.type,
          index: widget.index,
        )
      ],
    );
  }
}
