import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Video.dart';
import 'package:voice/model/VideoModel.dart';

class VideoItem extends StatefulWidget {
  final VideoModel videoModel;
  final Function refreshCallback;
  VideoItem({
    Key key,
    this.videoModel,
    this.refreshCallback,
  }) : super(key: key);
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  Future<void> deleteVideoCallback() async {
    try {
      var result = await deleteVideo(
        videoId: widget.videoModel.videoid,
      );
      if (result['noerr'] == 0) {
        await widget.refreshCallback();
        Toast.show(
          '删除成功',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      } else {
        Toast.show(
          '删除失败',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth / 3 - 16,
      margin: EdgeInsets.only(top: 4),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              width: screenWidth / 3 - 16,
              fit: BoxFit.cover,
              imageUrl: widget.videoModel.videoBanner,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: deleteVideoCallback,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    Icons.clear,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
