import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/injection_controller.dart';
import 'package:firebase_remote_config_example/remote_config_subscribtion.dart';
import 'package:firebase_remote_config_example/soccer/game_page.dart';
import 'package:firebase_remote_config_example/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class DeviceInspector extends StatelessWidget {
  const DeviceInspector({super.key, required this.remoteConfigSubscribtion});

  final RemoteConfigSubscribtion remoteConfigSubscribtion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeviceInspectorBloc>(),
      child: BlocBuilder<DeviceInspectorBloc, DeviceInspectorState>(
        builder: (context, state) {
          if (state is DeviceInspectorStateWebView) {
            remoteConfigSubscribtion.path = state.path;
          }
          return (state is DeviceInspectorStatePathWaiting)
              ? const SpalshPage()
              : (state is DeviceInspectorStateWrongPath)
                  ? const LandscapePage()
                  : (state is DeviceInspectorStateWebView)
                      ? WebViewWrapper(path: state.path)
                      : const LandscapePage();
        },
      ),
    );
  }
}

class WebViewWrapper extends StatefulWidget {
  const WebViewWrapper({
    Key? key,
    required this.path,
  }) : super(key: key);

  final String path;

  @override
  State<WebViewWrapper> createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.path,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
