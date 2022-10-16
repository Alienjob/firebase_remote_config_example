import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_example/device_inspector.dart';
import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/firebase_options.dart';
import 'package:firebase_remote_config_example/remote_config_subscribtion.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await [
    //  Permission.locationWhenInUse,
    Permission.phone,
  ].request();

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
