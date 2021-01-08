import 'package:agora/settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:flutter/material.dart';

class ProduceStream extends StatefulWidget {
  final String channelName;

  ProduceStream({this.channelName});

  @override
  _ProduceStreamState createState() => _ProduceStreamState();
}

class _ProduceStreamState extends State<ProduceStream> {
  RtcEngine _engine;

  @override
  void dispose() {
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

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
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        error: (code) {},
        joinChannelSuccess: (channel, uid, elapsed) {},
        leaveChannel: (stats) {},
        userJoined: (uid, elapsed) {},
        userOffline: (uid, elapsed) {},
        firstRemoteVideoFrame: (uid, width, height, elapsed) {}));
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _camPreview() {
    return Container(
        child: Column(
      children: <Widget>[_videoView(RtcLocalView.SurfaceView())],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _camPreview(),
      ),
    );
  }
}
