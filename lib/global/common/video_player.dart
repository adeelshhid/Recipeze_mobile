import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;
  bool isFullScreen = false;
  double volume = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      isPlaying = !isPlaying;
    });
  }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
      if (isFullScreen) {
        // Hide status bar and navigation bar for full-screen mode
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        // Restore system UI when exiting full-screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  void onSeek(double value) {
    setState(() {
      _controller.seekTo(Duration(seconds: value.toInt()));
    });
  }

  void onVolumeChanged(double value) {
    setState(() {
      volume = value;
      _controller.setVolume(volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Increase the height by wrapping the player with a container
              Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height * 0.5 + 50, // 50px added
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              // Play/Pause button overlay
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: togglePlayPause,
                ),
              ),
              // Full-Screen Button
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: toggleFullScreen,
                ),
              ),
              // Video control bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      // Progress bar
                      Slider(
                        value: _controller.value.position.inSeconds.toDouble(),
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        onChanged: onSeek,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time label
                          Text(
                            "${_controller.value.position.inMinutes}:${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')} / ${_controller.value.duration.inMinutes}:${(_controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                            style: TextStyle(color: Colors.white),
                          ),
                          // Volume control
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.volume_down,
                                    color: Colors.white),
                                onPressed: () {
                                  if (volume > 0.0) {
                                    onVolumeChanged(volume - 0.1);
                                  }
                                },
                              ),
                              Slider(
                                value: volume,
                                min: 0.0,
                                max: 1.0,
                                onChanged: onVolumeChanged,
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.volume_up, color: Colors.white),
                                onPressed: () {
                                  if (volume < 1.0) {
                                    onVolumeChanged(volume + 0.1);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
