import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';

class MapController extends ChangeNotifier {
  static final MapController _instance = MapController._internal();
  static final OpenRouteService openrouteservice = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248df3273ba3d46409d8f718de0d4746d28');
  Set<Marker> markers = {};
  LatLng currentLatLng = const LatLng(45.521563, -122.677433);
  late GoogleMapController? controller;
  String currentAddress = '';
  bool isError = false;
  bool isLoading = false;
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
    debugPrint("Current latlng: $currentLatLng");
    addressTextFieldController.text =
        localeController.getTranslate('loading-text');
    await getAddress(argument);
  }

  Future<String> getAddress(LatLng argument) async {
    isLoading = true;
    notifyListeners();
    String rs = '';
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(argument.latitude, argument.longitude);
      Placemark placemark = placemarks.first;
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
      isError = false;
    } catch (e) {
      rs = localeController.getTranslate('network-error');
      isError = true;
    }
    isLoading = false;
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

  Future<List<GeoJsonFeature>> getSuggestion(String s) async {
    if (s.isEmpty) {
      return [];
    }
    final collections = await openrouteservice.geocodeAutoCompleteGet(text: s);
    return collections.features;
  }
}
