part of media_picker;

@immutable
class AssetEntityImageProvider extends ImageProvider<AssetEntityImageProvider> {
  AssetEntityImageProvider(
    this.entity, {
    this.scale = 1.0,
    this.thumbSize = const ThumbnailSize(80, 80),
    this.isOriginal = true,
  }) : assert(
          isOriginal || thumbSize != null,
          'thumbSize must contain and only contain two integers when it\'s not original',
        ) {
    if (!isOriginal && thumbSize == null) {
      throw ArgumentError(
        'thumbSize must contain and only contain two integers when it\'s not original',
      );
    }
  }

  final AssetEntity entity;

  final double scale;

  final ThumbnailSize? thumbSize;

  final bool isOriginal;

  ImageFileType get imageFileType => _getType();

  ImageStreamCompleter load(
    AssetEntityImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<AssetEntityImageProvider>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<AssetEntityImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetEntityImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(
      AssetEntityImageProvider key, ImageDecoderCallback decode) async {
    assert(key == this);
    Uint8List data;
    if (isOriginal) {
      if (imageFileType == ImageFileType.heic) {
        data = await (await key.entity.file)!.readAsBytes();
      } else {
        data = (await key.entity.originBytes)!;
      }
    } else {
      data = (await key.entity.thumbnailDataWithSize(
          thumbSize!, ))!;
    }
    return decode(await ui.ImmutableBuffer.fromUint8List(data));
  }

  ImageFileType _getType() {
    ImageFileType? type;
    final String? extension = entity.title?.split('.').last;
    if (extension != null) {
      switch (extension.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          type = ImageFileType.jpg;
          break;
        case 'png':
          type = ImageFileType.png;
          break;
        case 'gif':
          type = ImageFileType.gif;
          break;
        case 'tiff':
          type = ImageFileType.tiff;
          break;
        case 'heic':
          type = ImageFileType.heic;
          break;
        default:
          type = ImageFileType.other;
          break;
      }
    }
    return type ?? ImageFileType.other;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return entity == other.entity &&
        scale == other.scale &&
        thumbSize == other.thumbSize &&
        isOriginal == other.isOriginal;
  }

  @override
  int get hashCode {
    return hashValues(
      entity,
      scale,
      thumbSize?.width ?? 0,
      thumbSize?.height ?? 0,
      isOriginal,
    );
  }
}

enum ImageFileType { jpg, png, gif, tiff, heic, other }

enum SpecialImageType { gif, heic }

class FadeImageBuilder extends StatelessWidget {
  const FadeImageBuilder({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext _, double value, Widget? __) {
        return Opacity(opacity: value, child: child);
      },
    );
  }
}
