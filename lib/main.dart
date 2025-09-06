import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'features/onboarding/onboarding_page.dart';
import 'features/location/location_page.dart';
import 'features/alarm/alarm_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // timezone setup - required for correct zonedSchedule behavior
  tz.initializeTimeZones();
  final String tzName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(tzName));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Onboarding App',
      initialRoute: "/",
      routes: {
        "/": (context) => const OnboardingPage(),
        "/location": (context) => const LocationPage(),
        "/alarm": (context) => const AlarmPage(),
      },
    );
  }
}
