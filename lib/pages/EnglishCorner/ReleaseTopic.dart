import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart'; //调用相机
import 'dart:io';
import 'package:photo/photo.dart'; //调用photo库
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart'; //图片压缩
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Topic.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:loading_dialog/loading_dialog.dart';

class ReleaseTopic extends StatefulWidget {
  _ReleaseTopicState createState() => _ReleaseTopicState();
}

class _ReleaseTopicState extends State<ReleaseTopic> {
  TextEditingController _messageController;
  String _topic = '';
  List _pickerData = ['每日一语', '上班摸鱼', '开心一下', '一图胜千言', '今天学到了', '画个知识点'];
  double _imageSize = 95.0;
  List<File> images = [];
  List<File> tempImages = [];
  List<Widget> imageList = []; //显示复数图片的数组
  Map<File, Widget> imagefileTowidget = {}; //图片file与组件的映射，用于删除图片
  bool _isSelected = true; //是否可选择图片
  LoadingDialog loading;
  initLoading(BuildContext context) {
    loading = LoadingDialog(
      buildContext: context,
      loadingMessage: '正在发布',
    );
  }

  void callCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera); //相机
    tempImages.add(image);
    await gzipImage();
    imagesToWidget();
  }

  void _pickImage() async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      rowCount: 4, //指定一行有几个
      maxSelected: 9 - images.length, //最多选择多少张图片，一共可以选择9张。
      padding: 1.0, //图片容器的内边距
      dividerColor: Colors.grey, //分隔线颜色
      disableColor: Colors.grey.shade300, //复选框禁用颜色
      itemRadio: 1, //内容项目radio
      textColor: Colors.white, //文字颜色
      thumbSize: 150, //预览拇指大小，默认为64
      sortDelegate: SortDelegate.common, //默认是常见的，或者您可以自定义委托来对图库进行排序
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
      badgeDelegate: const DurationBadgeDelegate(),
    );
    for (var e in imgList) {
      File _image = await e.file;
      // images.add(_image);
      tempImages.add(_image);
    }
    await gzipImage();
    imagesToWidget();
  }

  Future<void> gzipImage() async {
    for (num i = 0; i < tempImages.length; i++) {
      File file = await FlutterImageCompress.compressAndGetFile(
          tempImages[i].absolute.path,
          Directory.systemTemp.path + '/' + DateTime.now().toString() + '.jpg',
          minWidth: 1920,
          minHeight: 1080,
          quality: 60);
      tempImages[i] = file;
    }
  }

  void imagesToWidget() {
    List<Widget> tempImagesWidget = tempImages.map((image) {
      Widget imageWidget = Stack(
        alignment: const FractionalOffset(1.30, -0.3),
        children: <Widget>[
          Container(
            height: _imageSize,
            width: _imageSize,
            margin: EdgeInsets.all(4),
            child: Image.file(image, fit: BoxFit.cover),
          ),
          IconButton(
            color: Colors.grey[350],
            iconSize: 18,
            icon: Container(
              child: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0), //10像素圆角
              ),
            ),
            onPressed: () {
              setState(() {
                //删除选取的图片
                Widget removeWidget = imagefileTowidget[image];
                imageList.remove(removeWidget);
                images.remove(image);
                if (images.length < 9 && !_isSelected) {
                  _isSelected = true;
                  Widget selectWidget = selectImageWidget();
                  List<Widget> tempList = [];
                  tempList.add(selectWidget);
                  tempList.addAll(imageList);
                  imageList = tempList;
                }
              });
            },
          ),
        ],
      );
      imagefileTowidget[image] = imageWidget;
      return imageWidget;
    }).toList();

    setState(() {
      imageList.addAll(tempImagesWidget);
      images.addAll(tempImages);
      tempImages.clear();
      if (images.length == 9) {
        imageList.removeAt(0);
        _isSelected = false;
      }
    });
  }

  void showImageSheel() {
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
                        child: Text("拍照"),
                      ),
                      onTap: () {
                        //调用相机
                        Navigator.of(context).pop();
                        callCamera();
                      },
                    ),
                    ListTile(
                      title: Center(
                        child: Text("从本地相册选择"),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage();
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

  Widget selectImageWidget() {
    return Container(
      height: _imageSize,
      width: _imageSize,
      margin: EdgeInsets.all(4),
      color: Colors.grey[200],
      child: FlatButton(
          onPressed: () {
            //弹出选择图片
            showImageSheel();
          },
          child: Icon(
            Icons.add_a_photo,
            color: Colors.black26,
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    imageList.add(selectImageWidget());
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void showPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: _pickerData),
        changeToFirst: true,
        textAlign: TextAlign.center,
        textStyle: const TextStyle(color: Colors.blue, fontSize: 18),
        selectedTextStyle: TextStyle(color: Colors.red, fontSize: 18),
        columnPadding: const EdgeInsets.all(16.0),
        cancelText: '取消',
        cancelTextStyle: TextStyle(fontSize: 18, color: Colors.grey),
        confirmText: '确定',
        confirmTextStyle: TextStyle(fontSize: 18, color: Colors.orange[400]),
        onConfirm: (Picker picker, List value) {
          setState(() {
            _topic = picker.adapter.getSelectedValues()[0];
          });
        }).showModal(this.context);
  }

  void releaseHandler() async {
    // 发布
    try {
      String content = _messageController.text;
      if (content == '') {
        Toast.show(
          '内容不能为空',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
        return;
      }
      if (_topic == '') {
        Toast.show(
          '必须要选择一个话题',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
        return;
      }
      loading?.show();
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      var result = await releaseTopic(
        userId: userModel.userid,
        topicType: _topic,
        files: images,
        content: content,
      );
      loading?.hide();
      if (result['noerr'] == 0) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
    } catch (err) {
      Toast.show(
        '发布失败',
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _imageSize = screenWidth / 3 - 32;
    });
    initLoading(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('发布主题'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: releaseHandler,
            child: Text(
              '发布',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _messageController,
                maxLines: 6,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: '发布你的想法...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: _topic == ''
                  ? FlatButton.icon(
                      color: Colors.orangeAccent,
                      icon: Icon(Icons.add),
                      label: Text("选择话题"),
                      onPressed: () {
                        showPicker(context);
                      },
                    )
                  : FlatButton(
                      color: Colors.orangeAccent,
                      child: Text(_topic),
                      onPressed: () {
                        showPicker(context);
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Wrap(
                children: imageList,
              ),
            )
          ],
        ),
      ),
    );
  }
}
