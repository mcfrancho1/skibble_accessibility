import 'package:flutter/material.dart';

mixin LoadmoreMixin<T extends StatefulWidget> on State<T> {
  ScrollController scrollController = ScrollController();
  static const _lockTime = 1;
  bool _isLocking = false;

  @protected
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (!_isLocking) {
        if (scrollController.position.pixels /
                scrollController.position.maxScrollExtent >
            0.33) {
          _isLocking = true;
          onLoadMore();
          Future.delayed(const Duration(seconds: _lockTime)).then((_) {
            _isLocking = false;
          });
        }
      }
    });
  }

  @protected
  void onLoadMore();
}
