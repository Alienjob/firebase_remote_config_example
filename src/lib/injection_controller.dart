import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_example/device_inspector.dart';
import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/firebase_options.dart';
import 'package:firebase_remote_config_example/remote_config_subscribtion.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final sl = GetIt.instance;

ones() async {
  try {
    await OneSignal.shared.promptUserForPushNotificationPermission();
    await OneSignal.shared.setAppId('670d193e-b952-406e-9de6-34289b2d3f5e');
  } catch (e) {
    print(e);
  }
}

Future<void> init() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await [
  //  Permission.locationWhenInUse,
  //Permission.phone,
  //].request();
  await ones();

  sl.registerLazySingleton<FirebaseRemoteConfig>(
    () => FirebaseRemoteConfig.instance,
  );
  sl.registerLazySingleton<DeviceInspectorBloc>(
    () => DeviceInspectorBloc(),
  );
  sl.registerLazySingleton<DeviceInspector>(
    () => DeviceInspector(
      remoteConfigSubscribtion: sl(),
    ),
  );
  sl.registerLazySingleton<RemoteConfigSubscribtion>(
    () => RemoteConfigSubscribtion(remoteConfig: sl()),
  );

  sl<DeviceInspectorBloc>().add(const DeviceInspectorEventAppStart());
  sl<RemoteConfigSubscribtion>().start();
}
