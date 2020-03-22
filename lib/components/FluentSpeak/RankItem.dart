import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:voice/model/RankModel.dart';

class RankItem extends StatelessWidget {
  final RankModel rankModel;
  final int rank;
  RankItem({Key key, this.rankModel, this.rank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      imageUrl: rankModel.userImage,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                rank < 3
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/images/${rank.toString()}.png',
                          width: 30,
                          height: 30,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Container(
            child: Text(
              rankModel.userName,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(
            child: Text('${rankModel.index.toString()}分'),
          )
        ],
      ),
    );
  }
}
