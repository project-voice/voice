import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:voice/common/fonts/icons.dart';

class VedioAction extends StatefulWidget {
  final vedioData;
  VedioAction({Key key, this.vedioData}) : super(key: key);
  _VedioActionState createState() => _VedioActionState();
}

class _VedioActionState extends State<VedioAction> {
  VideoPlayerController videoController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
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
        Positioned(
            top: screenHeight / 2 + 50,
            right: 0,
            child: Container(
                width: 80,
                height: screenHeight / 2,
                padding: EdgeInsets.only(right: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ClipOval(
                          child: Image.network(
                        widget.vedioData['imgUrl'],
                        width: 50,
                      )),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                CustomIcons.heart,
                                color: widget.vedioData['isAction']
                                    ? Colors.red
                                    : Colors.white,
                                size: 40,
                              ),
                              Text(widget.vedioData['count'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ))
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 40,
                          ))
                    ])))
      ],
    );
  }
}
