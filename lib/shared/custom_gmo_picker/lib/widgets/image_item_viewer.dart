part of media_picker;

class ImageItemViewer extends StatelessWidget {
  const ImageItemViewer({Key? key, required this.image}) : super(key: key);
  final AssetEntityImageProvider image;

  Widget failedItemBuilder(BuildContext context) {
    return const Center(
      child: Text(
        "File error",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return ExtendedImage(
      image: image,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) {
        Widget loader = const SizedBox.shrink();
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            loader = const ColoredBox(color: Color(0x10ffffff));
            break;
          case LoadState.completed:
            loader = RepaintBoundary(
              child: FadeImageBuilder(
                child: state.completedWidget,
              ),
            );
            break;
          case LoadState.failed:
            loader = failedItemBuilder(context);
            break;
        }
        return loader;
      },
    );
  }
}
