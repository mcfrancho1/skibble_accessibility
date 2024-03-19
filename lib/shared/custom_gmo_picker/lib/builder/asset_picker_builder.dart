part of media_picker;

Duration get switchingPathDuration => kThemeAnimationDuration * 1.5;
bool get isAppleOS => Platform.isIOS || Platform.isMacOS;
Curve get switchingPathCurve => Curves.easeInOut;

class AssetPickerBuilder extends StatefulWidget {
  const AssetPickerBuilder({
    Key? key,
    this.limit = 9,
    this.type = RequestType.common,
    required this.routeDuration,
    this.isMulti = true,
    this.isReview = true,
    this.leadingBuilder,
    this.filterOptions,
  }) : super(key: key);
  final FilterOptionGroup? filterOptions;
  final int limit;
  final RequestType type;
  final Duration routeDuration;
  final bool isMulti, isReview;
  final WidgetBuilder? leadingBuilder;

  @override
  State<AssetPickerBuilder> createState() => _AssetPickerBuilderState();
}

class _AssetPickerBuilderState extends State<AssetPickerBuilder>
    with LoadmoreMixin, AfterLayoutMixin {
  final _assets = ValueNotifier(<AssetEntity>[]);
  final _selectedData = ValueNotifier(<AssetEntity>[]);
  final _pathEntityList = <AssetPathEntity?, Uint8List?>{};
  final _isLoading = ValueNotifier<bool>(true);
  final _currentPath = ValueNotifier<AssetPathEntity?>(null);
  final _isSwitchingPath = ValueNotifier<bool>(false);

  WidgetBuilder? get leadingBuilder => widget.leadingBuilder;
  Duration get routeDuration => widget.routeDuration;
  FilterOptionGroup? get filterOptions => widget.filterOptions;
  bool get isMulti => widget.isMulti;
  bool get isReview => widget.isReview;
  RequestType get type => widget.type;
  int get limit => widget.limit;
  List<AssetEntity> get assets => _assets.value;
  List<AssetEntity> get selecteds => _selectedData.value;
  bool get hasMoreToLoad => _assets.value.length < _totalAssetsCount;
  int get currentPage => (math.max(1, _assets.value.length) / _pageSize).ceil();

  int _totalAssetsCount = 0;
  int _pageSize = 80;
  ThumbnailSize _size = const ThumbnailSize(80, 80);
  @override
  void initState() {
    Future<void>.delayed(routeDuration).then((_) {
      getAssetPathList().whenComplete(() {
        getAssetList();
        registerObserve(_onLimitedAssetsUpdated);
      });
    });

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _pageSize = context.gridCount * 120;
    final size = context.width / context.gridCount;
    final scale = math.min(1, size / 100);
    _size = ThumbnailSize(size ~/ scale, size ~/ scale);
  }

  @override
  void dispose() {
    _assets.dispose();
    _selectedData.dispose();
    _isLoading.dispose();
    _currentPath.dispose();
    _isSwitchingPath.dispose();
    registerObserve(_onLimitedAssetsUpdated);
    super.dispose();
  }

  void _onLimitedAssetsUpdated(MethodCall methodCall) async {
    if (_currentPath.value != null) {
      await _currentPath.value?.fetchPathProperties();
      getAssetsFromEntity(_currentPath.value!);
    }
  }

  @override
  void onLoadMore() async {
    if (hasMoreToLoad) {
      final items =
          await _currentPath.value!.getAssetListPaged(page: currentPage, size: _pageSize);
      final List<AssetEntity> tempList = <AssetEntity>[];
      tempList.addAll(assets);
      tempList.addAll(items);
      _assets.value = tempList;
    }
  }

  Future<void> getAssetPathList() async {
    final FilterOptionGroup options = FilterOptionGroup()
      ..setOption(
        AssetType.audio,
        const FilterOption(needTitle: true),
      )
      ..setOption(
        AssetType.image,
        const FilterOption(
          needTitle: true,
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      );
    if (filterOptions != null) {
      options.merge(filterOptions!);
    }

    final _list = await PhotoManager.getAssetPathList(
      type: type,
      filterOption: options,
    );
    _list.sort((path1, path2) {
      if (path1.isAll) {
        return -1;
      }
      if (path2.isAll) {
        return 1;
      }
      return path1.name.toUpperCase().compareTo(path2.name.toUpperCase());
    });
    for (var pathEntity in _list) {
      _pathEntityList[pathEntity] = null;
      if (type != RequestType.audio) {
        getFirstThumbFromPathEntity(pathEntity).then((Uint8List? data) {
          _pathEntityList[pathEntity] = data;
        });
      }
    }
    if (_pathEntityList.isEmpty) {
      _isLoading.value = false;
    }
  }

  Future<void> getAssetList() async {
    if (_pathEntityList.isNotEmpty) {
      await getAssetsFromEntity(_pathEntityList.keys.elementAt(0)!);
    } else {
      assets.clear();
    }
  }

  Future<void> getAssetsFromEntity(AssetPathEntity pathEntity) async {
    _isSwitchingPath.value = false;
    if (_currentPath.value == pathEntity) {
      return;
    }
    _currentPath.value = pathEntity;
    _totalAssetsCount = await pathEntity.assetCountAsync;
    _selectedData.value = [];
    final items = await pathEntity.getAssetListPaged(page: 0, size: _pageSize);
    _assets.value = items;
    _isLoading.value = false;
  }

  Future<Uint8List?> getFirstThumbFromPathEntity(pathEntity) async {
    var list = await pathEntity.getAssetListRange(
      start: 0,
      end: 1,
    );
    final AssetEntity? asset = list.isEmpty ? null : list.elementAt(0);
    final assetData = await asset?.thumbnailDataWithSize(ThumbnailSize(80, 80));
    return assetData;
  }

  void togglePathEntity() {
    _isSwitchingPath.value = !_isSwitchingPath.value;
  }

  void onSelectItem(AssetEntity asset) {
    if (!isMulti) {
      if (!selecteds.contains(asset)) {
        _selectedData.value = List.from([asset]);
      }
    } else {
      if (selecteds.contains(asset)) {
        _selectedData.value = selecteds.where((e) => e != asset).toList();
      } else {
        if (selecteds.length < widget.limit) {
          _selectedData.value = [...selecteds, asset];
        }
      }
    }
  }

  void registerObserve([ValueChanged<MethodCall>? callback]) {
    if (callback == null) {
      return;
    }
    try {
      PhotoManager.addChangeCallback(callback);
      PhotoManager.startChangeNotify();
    } catch (e) {
      GmoMediaPicker.log('Error when registering assets callback: $e');
    }
  }

  void unregisterObserve([ValueChanged<MethodCall>? callback]) {
    if (callback == null) {
      return;
    }
    try {
      PhotoManager.removeChangeCallback(callback);
      PhotoManager.stopChangeNotify();
    } catch (e) {
      GmoMediaPicker.log('Error when unregistering assets callback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            return Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: _isLoading,
                  builder: (_, bool loading, Widget? child) {
                    return loading
                        ? const Center(child: CircularProgressIndicator())
                        : RepaintBoundary(child: _listAsset());
                  },
                ),
                ListBackdrop(
                  listener: _isSwitchingPath,
                  onTap: togglePathEntity,
                ),
                PathEntityList(
                  isAppleOS: isAppleOS,
                  switchingPathCurve: switchingPathCurve,
                  switchingPathDuration: switchingPathDuration,
                  currentPathEntity: _currentPath,
                  isSwitchingPath: _isSwitchingPath,
                  pathEntityList: _pathEntityList,
                  type: type,
                  height: constraints.maxHeight,
                  onTap: (AssetPathEntity val) {
                    getAssetsFromEntity(val);
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _listAsset() {
    return ValueListenableBuilder(
      valueListenable: _assets,
      builder: (_, List<AssetEntity> items, Widget? child) {
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          controller: scrollController,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.gridCount,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (_, int index) {
            final item = assets[index];
            return Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: _itemBuilder(index, item),
                  ),
                ),
                if (item.type == AssetType.audio ||
                    item.type == AssetType.video)
                  DurationIndicator(duration: item.duration),
                _selectBackdrop(index, item),
              ],
            );
          },
        );
      },
    );
  }

  Widget _selectBackdrop(int index, AssetEntity asset) {
    return ValueListenableBuilder(
      valueListenable: _selectedData,
      builder: (_, List<AssetEntity> items, Widget? child) {
        bool selected = items.contains(asset);
        return Stack(
          fit: StackFit.expand,
          children: [
            SelectedBackdrop(
              selected: selected,
              onReview: () => onReview(asset, index),
            ),
            SelectIndicator(
              selected: selected,
              onTap: () => onSelectItem(asset),
              isMulti: isMulti,
              gridCount: context.gridCount,
              selectText: (items.indexOf(asset) + 1).toString(),
            ),
          ],
        );
      },
    );
  }

  Widget _itemBuilder(int index, AssetEntity asset) {
    if (index == 0 && leadingBuilder != null) {
      return leadingBuilder!(context);
    }
    if (leadingBuilder != null) {
      index = index - 1;
    }
    switch (asset.type) {
      case AssetType.audio:
        return AudioItemViewer(title: asset.title);
      default:
        return ImageItemViewer(
          image: AssetEntityImageProvider(
            asset,
            isOriginal: false,
            thumbSize: _size,
          ),
        );
    }
  }

  void onReview(AssetEntity asset, int index) {
    if (widget.isReview) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MediaBuilderPreviewBuillder(
            assets: assets,
            index: index,
          ),
        ),
      );
    } else {
      onSelectItem(asset);
    }
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0.2,
      backgroundColor: Colors.white,
      leading: const CloseButton(color: Colors.black),
      title: PathEntitySelector(
        currentPathEntity: _currentPath,
        isSwitchingPath: _isSwitchingPath,
        togglePathEntity: togglePathEntity,
      ),
      actions: <Widget>[
        Center(
          child: ConfirmButton(
            selectedData: _selectedData,
            isMulti: isMulti,
            limit: limit,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
