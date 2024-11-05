import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ftwv_saqu/services/network/environment.dart';
import 'package:ftwv_saqu/utils/firebase/remote_config_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ftwv_saqu/utils/overide.dart';
import 'package:get/get.dart';
import 'app/route/app_routes.dart';
import 'app/route/observer_navigator.dart';
import 'app/route/screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await PlatformAssetBundle().load('assets/sit-obwebview.sta-wlabid.net.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  HttpOverrides.global = MyHttpOverrides();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await RemoteConfigUtils.initializeRemoteConfig();
  await Environment.initialize('dev');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Screen.splash,
      getPages: AppRoutes.getPages(),
      navigatorObservers: [ObserverNavigator()],
    );
  }
}