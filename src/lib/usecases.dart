import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carrier_info/carrier_info.dart';

Future<bool> checkEmulation() async {
  if (Platform.isAndroid) {
    var deviceData = await _getAndroidBuildData();

    CarrierData? carrierInfo;
    try {
      carrierInfo = await CarrierInfo.all;
    } catch (e) {
      print(e.toString());
    }

    String brand = deviceData['id'] +
        deviceData['display'] +
        deviceData['hardware'] +
        deviceData['brand'] +
        deviceData['device'];

    bool isEmulated = brand.toLowerCase().contains('google'); // &&simData !=
    isEmulated = isEmulated || (carrierInfo == null);
    return isEmulated;
  }

  //не андройд
  return true;
}

Future<String?> savedPath() async {
  var sh = await SharedPreferences.getInstance();
  String? path = sh.getString('url');
  // return null;
  return path;
}

Future<void> savePath(String path) async {
  var sh = await SharedPreferences.getInstance();
  sh.setString('url', path);
}

// Future<Map<String, dynamic>> _getSimInfo() async {
//   return <String, dynamic>{
//     'allowsVOIP': await SimInfo.getAllowsVOIP,
//     'carrierName': await SimInfo.getCarrierName,
//     'isoCountryCode': await SimInfo.getIsoCountryCode,
//     'mobileCountryCode': await SimInfo.getMobileCountryCode,
//     'mobileNetworkCode': await SimInfo.getMobileNetworkCode
//   };
// }

Future<Map<String, dynamic>> _getAndroidBuildData() async {
  AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'displaySizeInches':
        ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
    'displayWidthPixels': build.displayMetrics.widthPx,
    'displayWidthInches': build.displayMetrics.widthInches,
    'displayHeightPixels': build.displayMetrics.heightPx,
    'displayHeightInches': build.displayMetrics.heightInches,
    'displayXDpi': build.displayMetrics.xDpi,
    'displayYDpi': build.displayMetrics.yDpi,
  };
}
