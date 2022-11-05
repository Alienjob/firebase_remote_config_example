import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/injection_controller.dart';

class RemoteConfigSubscribtion {
  String? path;
  final FirebaseRemoteConfig remoteConfig;

  RemoteConfigSubscribtion({required this.remoteConfig});

  Future<void> start() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults({
      'url': '',
    });

    handleTimeout();
    scheduleTimeout(600);
  }

  Future<void> handleTimeout() async {
    // callback function
    await remoteConfig.fetchAndActivate();
    var newUrl = remoteConfig.getString('url');
    if (newUrl == '') {
      sl<DeviceInspectorBloc>().add(const DeviceInspectorEventPathEmpty());
    }
    if ((newUrl != path) && (newUrl != '')) {
      sl<DeviceInspectorBloc>()
          .add(DeviceInspectorEventChangePath(path: newUrl));
    }
  }

  Timer scheduleTimeout(int seconds) => Timer(
        Duration(seconds: seconds),
        () {
          handleTimeout();
        },
      );
}
