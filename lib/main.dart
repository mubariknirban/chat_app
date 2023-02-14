import 'package:chat_app/Screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage()
    );
  }
}


class Home extends StatelessWidget {
  final RemoteConfig config;
  const Home({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(config.getString('name'),style: TextStyle(
              color: Colors.black,fontSize: 18
            ),),
          ),
          ElevatedButton(
              onPressed: ()async{
                try{
                  await config.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 1),
                          minimumFetchInterval: Duration.zero));
                  await config.fetchAndActivate();
                  print('username---${config.getString('name')}');
                }catch(e){
                  print(e);
                }
              },
              child: Text("Click"))
        ],
      ),
    );
  }
}

Future<RemoteConfig> setupRemoteDate() async {
  final RemoteConfig remoteConfig = RemoteConfig.instance;
  await remoteConfig.fetch();
  await remoteConfig.activate();
  print('username---${remoteConfig.getString('name')}');
  return remoteConfig;
}