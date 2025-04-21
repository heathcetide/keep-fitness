import 'dart:convert';
import 'dart:typed_data';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:demo_project/api/user_api.dart';
import 'package:demo_project/common/Functions.dart';
import 'package:crypto/crypto.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final int index;
  final String? loadingImage;
  final List<Map<String, String>> images;

  const ImageView({
    super.key,
    required this.images,
    required this.index,
    this.loadingImage,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int index = 0;
  final UserApi userApi = UserApi();

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      this.index = index;
    });
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: ExtendedImage.network(
        widget.images[index]['url']!,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          if (state.extendedImageLoadState == LoadState.loading) {
            if (index == widget.index) {
              return Container(
                width: 100,
                height: 100,
                constraints: BoxConstraints.expand(),
                child: ExtendedImage.network(
                  fit: BoxFit.contain,
                  widget.loadingImage!,
                  cache: true,
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }

          return ExtendedRawImage(
            fit: BoxFit.contain,
            image: state.extendedImageInfo?.image,
          );
        },
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 12,
      heroAttributes: PhotoViewHeroAttributes(
        tag:
            widget.images[this.index]['tag'] ??
            widget.images[this.index]['url']!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).maybePop();
        },
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onLongPress: () {
                  showAdaptiveActionSheet(
                    context: context,
                    androidBorderRadius: 30,
                    actions: <BottomSheetAction>[
                      BottomSheetAction(
                        title: const Text('保存图片'),
                        onPressed: (context) async {
                          SmartDialog.showLoading(msg: '保存图片中');
                          await saveNetworkImage(
                            widget.images[index]['url']!,
                            context,
                          );
                          SmartDialog.dismiss();
                        },
                      ),
                      BottomSheetAction(
                        title: const Text('分享图片'),
                        onPressed: (context) async {
                          SmartDialog.showLoading(msg: '请稍后...');
                          try {
                            Uint8List imageData = await userApi.fetchImageData(
                              widget.images[index]['url']!,
                            );
                            SmartDialog.dismiss();
                          } catch (e) {
                            SmartDialog.dismiss();
                            print('Error sharing image: $e');
                          }
                        },
                      ),
                    ],
                  );
                },
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.images.length,
                  onPageChanged: onPageChanged,
                  scrollDirection: Axis.horizontal,
                  pageController: PageController(initialPage: index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
