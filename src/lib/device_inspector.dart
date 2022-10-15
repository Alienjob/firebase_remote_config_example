import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/injection_controller.dart';
import 'package:firebase_remote_config_example/remote_config_subscribtion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_remote_config_example/usecases.dart';

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

          return (state is DeviceInspectorStateWebView)
              ? WebView(initialUrl: state.path)
              : Image.asset('asset/background.png');
        },
      ),
    );
  }
}
