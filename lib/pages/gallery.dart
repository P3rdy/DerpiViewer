import 'package:cached_network_image/cached_network_image.dart';
import 'package:derpiviewer/enums.dart';
import 'package:derpiviewer/helpers/download.dart';
import 'package:derpiviewer/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class GalleryView extends StatefulWidget {
  final SearchInterface model;
  final int startIndex;
  const GalleryView({super.key, required this.model, required this.startIndex});
  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late SearchInterface _model;
  late PageController _pageController;
  @override
  void initState() {
    _model = widget.model;
    _pageController = PageController(initialPage: widget.startIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PhotoViewGallery.builder(
        itemCount: _model.getItemCount(),
        builder: ((context, index) {
          return PhotoViewGalleryPageOptions.customChild(
            child: () {
              if (_model.getItemFormat(index) == ContentFormat.webm) {
                return VideoView(
                  src: _model.getItemUrl(index, Size.medium),
                );
              } else {
                return Center(
                    child: CachedNetworkImage(
                  imageUrl: _model.getItemUrl(index, Size.full),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(
                    value: progress.progress,
                  )),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline),
                ));
              }
            }(),
            initialScale: PhotoViewComputedScale.contained * 1.0,
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.covered * 4.0,
            heroAttributes:
                PhotoViewHeroAttributes(tag: _model.getItemID(index)),
          );
        }),
        pageController: _pageController,
      ),
      GalleryToolBar(
        model: _model,
        controller: _pageController,
      )
    ]));
  }
}

class VideoView extends StatefulWidget {
  final String src;
  const VideoView({super.key, required this.src});
  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late String _src;
  @override
  void initState() {
    _src = widget.src;
    _videoPlayerController = VideoPlayerController.network(_src);
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.isInitialized
        ? Stack(children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Center(
                    child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ))),
            Align(
              alignment: Alignment.center,
              child: PauseAnim(tapCallback: () {
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
              }),
            )
          ])
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}

class PauseAnim extends StatefulWidget {
  final Function tapCallback;
  const PauseAnim({Key? key, required this.tapCallback}) : super(key: key);

  @override
  State<PauseAnim> createState() => _PauseAnimState();
}

class _PauseAnimState extends State<PauseAnim> {
  bool _visible = true;
  bool _isPlaying = false;
  late Function _tapCallback;
  @override
  void initState() {
    _tapCallback = widget.tapCallback;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: 400.0,
        child: GestureDetector(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: _isPlaying
                ? const Icon(
                    Icons.pause,
                    size: 100,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.play_arrow,
                    size: 100,
                    color: Colors.white,
                  ),
          ),
          onTap: () {
            _isPlaying = !_isPlaying;
            _visible = !_visible;
            setState(() {
              _tapCallback();
            });
          },
        ));
  }
}

class GalleryToolBar extends StatelessWidget {
  SearchInterface model;
  PageController controller;
  GalleryToolBar({super.key, required this.model, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.only(bottom: 8, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: IconButton(
                  onPressed: (() {}),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ))),
          Expanded(
              child: IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () async {
              int idx = controller.page!.round();
              if (controller.page != null) {
                if (model.getItemFormat(idx) == ContentFormat.webm) {
                  Fluttertoast.showToast(msg: "Downloading");
                }
                DownloadHelper.downloadFile(
                    model.getItemUrl(idx, Size.full),
                    model.getBooru(),
                    model.getItemID(idx),
                    ConstStrings.format[model.getItemFormat(idx).index]);
              }
            },
          )),
          Expanded(
              child: IconButton(
                  onPressed: () async {
                    int idx = controller.page!.round();
                    DownloadHelper.shareFile(
                        model.getItemUrl(
                            idx,
                            (model.getItemFormat(idx) == ContentFormat.webm)
                                ? Size.thumb
                                : Size.large),
                        model.getBooru(),
                        model.getItemID(idx),
                        model.getItemFormat(idx));
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ))),
          Expanded(
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}
