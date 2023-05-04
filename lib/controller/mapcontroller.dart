import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends ChangeNotifier {
  static final MapController _instance = MapController._internal();
  static const String kGoogleApiKey = 'AIzaSyBsMkcCb61CevxuTKee09quBOI0qbo6BFA';
  Set<Marker> markers = {};
  LatLng currentLatLng = const LatLng(45.521563, -122.677433);
  late GoogleMapController? controller;
  String currentAddress = '';
  TextEditingController addressTextFieldController = TextEditingController();
  MapController._internal();

  factory MapController() {
    return _instance;
  }

  void addMarker(LatLng argument) async {
    markers = {
      Marker(
        markerId: MarkerId(argument.toString()),
        position: argument,
      ),
    };
    notifyListeners();
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: argument, zoom: 20),
      ),
    );
    currentLatLng = argument;
    addressTextFieldController.text =
        LocalizationController().getTranslate('loading-text');
    await getAddress(argument);
  }

  Future<String> getAddress(LatLng argument) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(argument.latitude, argument.longitude);
    Placemark placemark = placemarks.first;
    String rs = '';
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      rs = placemark.street!;
    }
    if (placemark.subAdministrativeArea != null &&
        placemark.subAdministrativeArea!.isNotEmpty) {
      rs += ', ${placemark.subAdministrativeArea}';
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      rs += ', ${placemark.administrativeArea}';
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      rs += ', ${placemark.subLocality}';
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      rs += ', ${placemark.locality}';
    }
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      rs += ', ${placemark.country}';
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      rs += ', ${placemark.postalCode}';
    }
    addressTextFieldController.text = rs;
    notifyListeners();
    return rs;
  }

  void setAddress(LatLng address) async {
    currentAddress = await getAddress(address);
  }

  List<num> getLatLng() {
    return [currentLatLng.latitude, currentLatLng.longitude];
  }
}
