import 'package:flutter/material.dart';
import '../../../networks/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _service = LocationService();

  String _location = "No location selected yet";
  bool _isLoading = false;

  String get location => _location;
  bool get isLoading => _isLoading;

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();

    final pos = await _service.getCurrentPosition();
    if (pos == null) {
      _location = "Unable to get location. Please enable location services.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    final address = await _service.getAddressFromPosition(pos);
    if (address != null) {
      _location = address;
    } else {
      _location = "Lat: ${pos.latitude}, Lng: ${pos.longitude}";
    }

    _isLoading = false;
    notifyListeners();
  }
}
