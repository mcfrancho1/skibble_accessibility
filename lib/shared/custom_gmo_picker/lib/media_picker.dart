library media_picker;

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mixins/after_layout.dart';
import 'mixins/loadmore_mixin.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

export 'package:photo_manager/photo_manager.dart';

part 'asset_entity_image_provider.dart';
part 'builder/asset_picker_builder.dart';
part 'builder/media_builder_preview.dart';
part 'builder/audio_page_builder.dart';
part 'builder/image_page_builder.dart';
part 'builder/video_page_builder.dart';
part 'builder/video_progress.dart';
part 'widgets/path_entity_selector.dart';
part 'widgets/path_entity_widget.dart';
part 'widgets/select_indicator.dart';
part 'widgets/path_list_entity.dart';
part 'widgets/audio_item_viewer.dart';
part 'widgets/duration_indicator.dart';
part 'widgets/image_item_viewer.dart';
part 'widgets/confirm_button.dart';
part 'widgets/list_backdrop.dart';

class ZoomImageItem {
  ZoomImageItem({this.path, this.isVideo = false, this.thumbnail});
  final String? path;
  final bool isVideo;
  final String? thumbnail;
}

typedef MulCallback = void Function(List<AssetEntity>);

typedef SingleCallback = void Function(AssetEntity);

typedef Callback = void Function(AssetEntity);

class GmoMediaPicker {
  factory GmoMediaPicker() => _instance;
  GmoMediaPicker._internal();
  static final GmoMediaPicker _instance = GmoMediaPicker._internal();

  static Future<List<AssetEntity>?> picker(
    BuildContext context, {
    RequestType type = RequestType.common,
    int limit = 10,
    MulCallback? mulCallback,
    SingleCallback? singleCallback,
    Duration routeDuration = const Duration(milliseconds: 300),
    bool isMulti = false,
    bool isReview = true,
    WidgetBuilder? leadingBuilder,
    FilterOptionGroup? filterOptions,
  }) async {
    final PermissionState permissionState = await PhotoManager.requestPermissionExtend();
    if (permissionState.isAuth) {
      return await Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (_) => AssetPickerBuilder(
            routeDuration: routeDuration,
            type: type,
            isMulti: isMulti,
            limit: limit,
            leadingBuilder: leadingBuilder,
            filterOptions: filterOptions,
            isReview: isReview,
          ),
        ),
      )
          .then((data) {
          if (data != null) {
            if (mulCallback != null && isMulti) {
              mulCallback(data as List<AssetEntity>);
              return data as List<AssetEntity>;
            }
            else if (singleCallback != null && !isMulti) {
              singleCallback.call(data.first as AssetEntity);
              return data;
            }
            else {
              return data;
            }
          }
          else {
            return [];
          }
        },
      );
    }

    else {
      PhotoManager.openSetting();
    }

    return null;
  }

  static String formatDuration(Duration duration) {
    return <int>[duration.inMinutes, duration.inSeconds]
        .map((int e) => e.remainder(60).toString().padLeft(2, "0"))
        .join(':');
  }

  static void log(dynamic message, {String tag = ''}) {
    developer.log(message.toString(), name: tag);
  }

  static Size sizeImage(
    double currentWidth,
    double currentHeight, {
    required double targetWidth,
    required double targetHeight,
  }) {
    double w = currentWidth;
    double h = currentHeight;
    final double wd = w / targetWidth;
    final double hd = h / targetHeight;
    final double be = math.max(1, math.max(wd, hd));
    w = w / be;
    h = h / be;
    return Size(w, h);
  }
}

extension ContextExt on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  Color get primary => colorScheme.primary;
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  int get gridCount => (width / 100) ~/ math.min(1, (width / 100) / 4);
  EdgeInsets get padding => mediaQuery.padding;
}

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    this.width = 50.0,
    this.padding,
    this.color,
  }) : super(key: key);

  final double width;
  final Color? color;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(10.0),
        child: SizedBox(
          width: width,
          height: width,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? context.primary,
            ),
          ),
        ),
      ),
    );
  }
}
