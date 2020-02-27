import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class HeaderImage extends StatelessWidget {
  final UserModel userModel;
  HeaderImage({Key key, this.userModel}) : super(key: key);

  Function updateHeadImage(BuildContext context) {
    return () async {
      try {
        // 获取图片
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          return;
        }
        // 压缩
        File file = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          Directory.systemTemp.path + '/' + DateTime.now().toString() + '.jpg',
          minWidth: 1920,
          minHeight: 1080,
          quality: 60,
        );
        var result = await updateUserInfo(
          userid: userModel.userid,
          key: 'user_image',
          value: file,
        );
        if (result['noerr'] == 0) {
          await Provider.of<UserProvider>(context, listen: false)
              .setUserMessage('image', result['data']);
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
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: updateHeadImage(context),
      child: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.only(left: 16, right: 16),
        margin: EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    '头像：',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ClipOval(
                    child: userModel.userImage != null
                        ? CachedNetworkImage(
                            width: 40,
                            height: 40,
                            imageUrl: userModel.userImage,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : Image.asset(
                            'assets/images/person-head.jpeg',
                            width: 40,
                            height: 40,
                          ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
