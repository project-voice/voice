import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

class Refresh extends StatefulWidget {
  final child;
  final Future<void> Function(EasyRefreshController controller) onLoadCallback;
  final Future<void> Function(EasyRefreshController controller)
      onRefreshCallback;
  Refresh(
      {Key key,
      @required this.child,
      @required this.onLoadCallback,
      @required this.onRefreshCallback})
      : super(key: key);
  _RefreshState createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  // 加载控制器
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.finishLoad(success: true);
    _easyRefreshController.finishRefresh(success: true);
    _easyRefreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      controller: _easyRefreshController,
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      onRefresh: () async {
        return widget.onRefreshCallback(_easyRefreshController);
      },
      onLoad: () async {
        return widget.onLoadCallback(_easyRefreshController);
      },
      footer: MaterialFooter(),
      header: MaterialHeader(),
      child: widget.child,
    );
  }
}
