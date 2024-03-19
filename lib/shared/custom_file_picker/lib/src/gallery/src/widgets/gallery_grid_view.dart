import 'dart:typed_data';


import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';

import '../../../../drishya_picker.dart';
import '../repo/gallery_repository.dart';
import 'album_builder.dart';
import 'gallery_builder.dart';
import 'gallery_permission_view.dart';
import 'lazy_load_scroll_view.dart';

///
class GalleryGridView extends StatelessWidget {
  ///
  const GalleryGridView({
    Key? key,
    required this.controller,
    required this.albums,
    required this.onClosePressed,
    required this.onPictureTaken
  }) : super(key: key);

  ///
  final GalleryController controller;
  final Function(XFile? cameraFile)? onPictureTaken;

  ///
  final Albums albums;

  ///
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: controller.panelSetting.foregroundColor,
      child: CurrentAlbumBuilder(
        albums: albums,
        builder: (context, album, child) {
          return ValueListenableBuilder<AlbumValue>(
            valueListenable: album,
            builder: (context, value, child) {
              // Error
              if (value.state == BaseState.unauthorised &&
                  value.entities.isEmpty) {
                return GalleryPermissionView(
                  onRefresh: () {
                    if (value.assetPathEntity == null) {
                      albums.fetchAlbums(controller.setting.requestType);
                    } else {
                      album.fetchAssets();
                    }
                  },
                );
              }

              // No data
              if (value.state == BaseState.completed &&
                  value.entities.isEmpty) {
                return const Center(
                  child: Text(
                    'No media available',
                    style: TextStyle(
                      color: kLightSecondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              if (value.state == BaseState.error) {
                return const Center(
                  child: Text(
                    'Something went wrong. Please try again!',
                    style: TextStyle(
                      color: kLightSecondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              final entities = value.entities;
              final enableCamera = controller.setting.enableCamera;

              final itemCount = albums.value.state == BaseState.fetching
                  ? 1
                  : enableCamera
                      ? entities.length + 1
                      : entities.length;

              return LazyLoadScrollView(
                onEndOfPage: album.fetchAssets,
                scrollOffset: MediaQuery.of(context).size.height * 0.4,
                child: GridView.builder(
                  controller: controller.panelController.scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: controller.setting.crossAxisCount ?? 3,
                    crossAxisSpacing: 1.5,
                    mainAxisSpacing: 1.5,
                  ),
                  itemCount: itemCount,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    if (enableCamera && index == 0) {
                      return InkWell(
                        onTap: () {
                          var result = controller.openCamera(context).then((value) {
                            if (value != null) {
                              album.insert(value);
                            }
                          });

                        },
                        child: Icon(
                          CupertinoIcons.camera,
                          color: kPrimaryColor,
                          size: 26,
                        ),
                      );
                    }

                    final ind = enableCamera ? index - 1 : index;

                    final entity = albums.value.state == BaseState.fetching
                        ? null
                        : entities[ind];

                    if (entity == null) return const SizedBox();

                    return _MediaTile(controller: controller, entity: entity);
                  },
                ),
              );
            },
          );

          //
        },
      ),
    );
  }
}

///
class _MediaTile extends StatelessWidget {
  ///
  const _MediaTile({
    Key? key,
    required this.entity,
    required this.controller,
  }) : super(key: key);

  ///
  final GalleryController controller;

  ///
  final AssetEntity entity;

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;

    final drishya = entity.toSkibble;

    return ColoredBox(
      color: Colors.grey.shade800,
      child: InkWell(
        onTap: () {
          final entity = drishya.copy(pickedThumbData: bytes);
          controller.select(context, entity);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            EntityThumbnail(
              entity: drishya,
              onBytesGenerated: (b) {
                bytes = b;
              },
            ),
            _SelectionCount(controller: controller, entity: entity),
          ],
        ),
      ),
    );
  }
}

class _SelectionCount extends StatelessWidget {
  const _SelectionCount({
    Key? key,
    required this.controller,
    required this.entity,
  }) : super(key: key);

  final GalleryController controller;
  final AssetEntity entity;

  @override
  Widget build(BuildContext context) {
    return GalleryBuilder(
      controller: controller,
      builder: (value, child) {
        final actionBased =
            controller.setting.selectionMode == SelectionMode.actionBased;

        final singleSelection = actionBased
            ? !value.enableMultiSelection
            : controller.singleSelection;

        final isSelected = value.selectedEntities.contains(entity);
        final index = value.selectedEntities.indexOf(entity.toSkibble);

        Widget counter = const SizedBox();

        if (isSelected) {
          counter = CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 14,
            child: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          );
        }

        if (actionBased && !singleSelection) {
          counter = Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: isSelected ? counter : const SizedBox(),
          );
        }

        return Container(
          color: isSelected ? Colors.white38 : Colors.transparent,
          padding: const EdgeInsets.all(6),
          child: Align(
            alignment: actionBased ? Alignment.topRight : Alignment.center,
            child: counter,
          ),
        );
      },
    );
  }
}
