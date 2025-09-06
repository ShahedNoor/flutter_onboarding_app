import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';

import 'features/onboarding/onboarding_page.dart';
import 'features/location/pages/location_page.dart';
import 'features/location/providers/location_provider.dart';
import 'features/alarm/pages/alarm_page.dart';
import 'features/alarm/providers/alarm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // timezone setup
  tz.initializeTimeZones();
  final String tzName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(tzName));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
