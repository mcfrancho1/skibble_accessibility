part of media_picker;

class PathEntityWidget extends StatelessWidget {
  const PathEntityWidget({
    Key? key,
    required this.path,
    required this.isAppleOS,
    required this.type,
    required this.pathEntityList,
    required this.onTap,
    required this.currentPathEntity,
  }) : super(key: key);
  final AssetPathEntity path;
  final bool isAppleOS;
  final RequestType type;
  final Map<AssetPathEntity?, Uint8List?> pathEntityList;
  final Function(AssetPathEntity) onTap;
  final ValueListenable<AssetPathEntity?> currentPathEntity;
  @override
  Widget build(BuildContext context) {
    Widget builder() {
      if (type == RequestType.audio) {
        return ColoredBox(
          color: Colors.white.withOpacity(0.12),
          child: const Center(
            child: Icon(Icons.audiotrack, color: Colors.black),
          ),
        );
      }

      final thumbData = pathEntityList[path];
      if (thumbData != null) {
        return Image.memory(thumbData, fit: BoxFit.cover);
      } else {
        return ColoredBox(
          color: context.colorScheme.primary.withOpacity(0.12),
        );
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
          onTap: () {
            onTap.call(path);
          },
          splashFactory: InkSplash.splashFactory,
          child: SizedBox(
            height: isAppleOS ? 64.0 : 52.0,
            child: Row(
              children: <Widget>[
                RepaintBoundary(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: builder(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              path.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text(
                          '(${path.assetCountAsync})',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: currentPathEntity,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Icon(
                      Icons.check,
                      size: 26.0,
                      color: context.primary,
                    ),
                  ),
                  builder: (_, dynamic value, Widget? child) {
                    if (value == path) {
                      return child!;
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          )),
    );
  }
}
