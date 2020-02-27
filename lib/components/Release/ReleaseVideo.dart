import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:voice/api/Video.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:loading_dialog/loading_dialog.dart';

class ReleaseVideo extends StatefulWidget {
  _ReleaseVideoState createState() => _ReleaseVideoState();
}

class _ReleaseVideoState extends State<ReleaseVideo> {
  TextEditingController _textEditingController;
  VideoPlayerController _videoController;
  LoadingDialog loading;
  File selectedVideo;
  bool isSelected = false;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  initLoading(BuildContext context) {
    loading = LoadingDialog(
      buildContext: context,
      loadingMessage: '正在发布',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
    _videoController?.dispose();
  }

  Future<void> releaseHandler() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      String description = _textEditingController?.text;
      File file = selectedVideo;
      if (description == '') {
        Toast.show(
          '描述不能为空',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
        return;
      }
      if (file == null) {
        Toast.show(
          '您还未选择视频',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
        return;
      }
      loading?.show();
      var result = await releaseVideo(
        userid: userModel.userid,
        videoDescription: description,
        file: file,
      );
      loading?.hide();
      if (result['noerr'] == 0) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          Navigator.of(context).pop();
        });
      }
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
    } catch (err) {
      print(err);
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text('请选择',
                            style: TextStyle(color: Colors.black26)),
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: Text("录像"),
                      ),
                      onTap: () {
                        //调用相机
                        Navigator.of(context).pop();
                        _callCamera();
                      },
                    ),
                    ListTile(
                      title: Center(
                        child: Text("从本地相册选择"),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickVideo();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                color: Colors.black26,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Center(
                    child: Text(
                      "取消",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<void> _callCamera() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
    setState(() {
      selectedVideo = video;
      _videoController = VideoPlayerController.file(selectedVideo)
        ..setLooping(true)
        ..initialize().then((value) {
          setState(() {});
        });
      isSelected = true;
    });
  }

  Future<void> _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    int size = await video.length();
    if (size >= 8000000) {
      Toast.show(
        '上传视频大小不得超过8MB，请自行压缩',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
      return;
    }

    setState(() {
      selectedVideo = video;
      _videoController = VideoPlayerController.file(selectedVideo)
        ..setLooping(true)
        ..initialize().then((value) {
          setState(() {});
        });
      isSelected = true;
    });
  }

  void selectVideo() {
    showBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    initLoading(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('发布视频'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: releaseHandler,
            child: Text(
              '发布',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Container(
        width: screenWidth,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              maxLength: 50,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '写下你的描述',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
              ),
            ),
            Container(
              width: screenWidth,
              height: 0.5,
              color: Colors.grey[300],
            ),
            SingleChildScrollView(
              child: Container(
                height: 250,
                width: screenWidth,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isSelected
                    ? Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _videoController?.pause();
                              setState(() {
                                isPlaying = false;
                              });
                            },
                            child: VideoPlayer(_videoController),
                          ),
                          isPlaying
                              ? Container()
                              : Positioned(
                                  left: screenWidth / 2 - 36,
                                  top: 105,
                                  child: GestureDetector(
                                    onTap: () {
                                      _videoController?.play();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      size: 40,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = false;
                                  _videoController?.pause();
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 4,
                                      )
                                    ]),
                                child: Center(
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : FlatButton(
                        onPressed: selectVideo,
                        child: Icon(
                          Icons.video_call,
                          size: 50,
                          color: Colors.black26,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
