import 'package:flutter/material.dart';
import 'package:flutter_onboarding_app/colors/colors.dart';
import 'package:flutter_onboarding_app/common_widgets/my_button.dart';
import 'package:flutter_onboarding_app/features/location/location_data.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _location = "No location selected yet";

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _location = "Location services are disabled.");
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _location = "Permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(
        () => _location =
            "Permission permanently denied. Please enable from settings.",
      );
      return;
    }

    // Get current position
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _location = "Selected Location: ${pos.latitude}, ${pos.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = locationData[0];
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
              Text(_location, style: TextStyle(color: AppColors.onPrimary)),
              const SizedBox(height: 30),

              // Use Current Location Button
              GestureDetector(
                onTap: _getLocation, // 🔑 moved here
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
