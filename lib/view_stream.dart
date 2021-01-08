import 'package:agora/settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

class ViewStream extends StatefulWidget {
  final String channelName;

  ViewStream({this.channelName});

  @override
  _ViewStreamState createState() => _ViewStreamState();
}

class _ViewStreamState extends State<ViewStream> {
  int _userId = null;

  /// AGORA VIDEO STREAMING
  RtcEngine _engine;

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Audience);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        error: (code) {},
        joinChannelSuccess: (channel, uid, elapsed) {},
        leaveChannel: (stats) {},
        userJoined: (uid, elapsed) {
          setState(() {
            _userId = uid;
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            _userId = uid;
          });
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {}));
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video layout wrapper
  Widget _streamVideo() {
    if (_userId == null) {
      return Container();
    }
    return Container(
      child: Column(
        children: <Widget>[_videoView(RtcRemoteView.SurfaceView(uid: _userId))],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _streamVideo()
      ),
    );
  }
}
