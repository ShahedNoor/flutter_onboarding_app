import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/my_button.dart';
import '../../../constants/colors.dart';
import '../data/location_data.dart';
import '../providers/location_provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
void initState() {
  super.initState();
  _requestPermissions();
}

Future<void> _requestPermissions() async {
  // Notification permission
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Location permission
  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }
}


  @override
  Widget build(BuildContext context) {
    final data = locationData[0];
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.title,
                style: TextStyle(color: AppColors.onPrimary, fontSize: 28),
              ),
              const SizedBox(height: 16),
              Text(
                data.subtitle,
                style: TextStyle(color: AppColors.onPrimary, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Image.asset(data.image),
              const SizedBox(height: 30),

              // Loader or Location text
              locationProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      locationProvider.location,
                      style: TextStyle(color: AppColors.onPrimary),
                      textAlign: TextAlign.center,
                    ),

              const SizedBox(height: 30),

              // Use Current Location Button
              GestureDetector(
                onTap: () async {
                  await locationProvider.fetchLocation();
                  if (context.mounted &&
                      !locationProvider.isLoading &&
                      locationProvider.location.isNotEmpty) {
                    Navigator.pushNamed(context, "/alarm");
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Use Current Location",
                          style: TextStyle(color: AppColors.onPrimary),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          "assets/images/location_page_images/location-icon.png",
                          height: 24,
                          width: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              MyButton(
                onTap: () => Navigator.pushNamed(context, "/alarm"),
                buttonText: "Home",
                buttonBackgroundColor: AppColors.onPrimary.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}