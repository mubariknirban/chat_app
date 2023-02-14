import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';


class RemoteConfigure{

  static Future<FirebaseRemoteConfig> getDate() async{

    await  Firebase.initializeApp();
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: Duration.zero));
    await remoteConfig.fetchAndActivate();
    print('username---${remoteConfig.getString('name')}');

    return remoteConfig;
  }
}