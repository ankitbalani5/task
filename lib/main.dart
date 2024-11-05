import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/Bloc/scheme_bloc.dart';
import 'package:task/Screens/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task/push_notification_service.dart';
import 'Constant.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FireBaseNotification notificationService = FireBaseNotification();
  await notificationService.initializeNotification();

  Constant.fcmToken = await FirebaseMessaging.instance.getToken();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var login = pref.getBool('login');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SchemeBloc>(create: (context) => SchemeBloc(),)
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Loginscreen(),
        )
    );

  }
}

