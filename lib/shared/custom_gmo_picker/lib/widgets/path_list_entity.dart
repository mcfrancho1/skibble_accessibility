part of media_picker;

class PathEntityList extends StatelessWidget {
  const PathEntityList({
    Key? key,
    required this.isAppleOS,
    required this.switchingPathCurve,
    required this.switchingPathDuration,
    required this.isSwitchingPath,
    required this.pathEntityList,
    required this.currentPathEntity,
    required this.onTap,
    required this.type,
    required this.height,
  }) : super(key: key);
  final bool isAppleOS;
  final Duration switchingPathDuration;
  final Curve switchingPathCurve;
  final ValueListenable<bool> isSwitchingPath;
  final Map<AssetPathEntity?, Uint8List?> pathEntityList;
  final RequestType type;
  final Function(AssetPathEntity) onTap;
  final ValueListenable<AssetPathEntity?> currentPathEntity;
  final double height;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isSwitchingPath,
      builder: (_, bool val, Widget? child) {
        return AnimatedPositioned(
          duration: switchingPathDuration,
          curve: switchingPathCurve,
          top: isAppleOS
              ? !val
                  ? -height
                  : 0
              : -(!val ? height : 1.0),
          child: AnimatedOpacity(
            duration: switchingPathDuration,
            curve: switchingPathCurve,
            opacity: !isAppleOS || val ? 1.0 : 0.0,
            child: Container(
              width: context.width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: isAppleOS
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      )
                    : null,
                color: Colors.white,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 1.0),
                itemCount: pathEntityList.length,
                itemBuilder: (BuildContext _, int index) {
                  return PathEntityWidget(
                    path: pathEntityList.keys.elementAt(index)!,
                    isAppleOS: isAppleOS,
                    currentPathEntity: currentPathEntity,
                    onTap: onTap,
                    pathEntityList: pathEntityList,
                    type: type,
                  );
                },
                separatorBuilder: (BuildContext _, int __) => Container(
                  margin: const EdgeInsets.only(left: 60.0),
                  height: .5,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
