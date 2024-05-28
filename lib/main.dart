import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_secretary/services/notifications/notification_service.dart';
import 'firebase_options.dart';
import 'screens/tasks_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Secretary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0Xff1fcd99)),
        useMaterial3: true,
        fontFamily: "Changa",
        scaffoldBackgroundColor: Color(0Xff3f10c7),
        textTheme: TextTheme(bodyLarge: TextStyle(), bodyMedium: TextStyle(), bodySmall: TextStyle()).apply(bodyColor: Color(0Xff7756c2), displayColor: Color(0Xff7756c2)),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0X00),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 30,
                fontFamily: "Changa"
            )),
      ),
      home: const TasksPage(),
    );
  }
}
