import 'package:flutter/material.dart';

class BaseInfo extends StatelessWidget {
  final String baseInfo;
  BaseInfo({Key key, this.baseInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kim',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              '暂无简介',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        '0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.red[400],
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          '关注者',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: .5,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.red[400],
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          '正在关注',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
