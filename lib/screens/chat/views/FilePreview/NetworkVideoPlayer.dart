import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkVideoPlayerView extends StatefulWidget {
  final String videoUrl;

  NetworkVideoPlayerView({this.videoUrl});

  @override
  _NetworkVideoPlayerViewState createState() => _NetworkVideoPlayerViewState();
}

class _NetworkVideoPlayerViewState extends State<NetworkVideoPlayerView> {
  BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoDetectFullscreenAspectRatio: true,
      autoPlay: true,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    _betterPlayerController.addEventsListener((p0) async {
      if (p0.betterPlayerEventType == BetterPlayerEventType.finished) {
        Get.back();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: BetterPlayer(
                        controller: _betterPlayerController,
                        key: _betterPlayerKey,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                left: 5,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.cancel, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
