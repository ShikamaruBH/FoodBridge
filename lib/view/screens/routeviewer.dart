import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/widget_controller/mapcontroller.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ViewRouteScreen extends StatelessWidget {
  final double lat;
  final double lng;
  const ViewRouteScreen(this.lat, this.lng, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (__, localeController, _) => Scaffold(
            appBar: AppBar(
              title:
                  Text(localeController.getTranslate('donation-route-title')),
              leading: IconButton(
                onPressed: () {
                  mapController.controller?.dispose();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            body: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: ChangeNotifierProvider.value(
                value: mapController,
                child: Consumer<MapController>(
                  builder: (__, ___, _) => GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: mapController.currentLatLng,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    buildingsEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    onMapCreated: (controller) async {
                      mapController.controller = controller;
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => const LoadingDialog(
                          message: 'loading-route-text',
                        ),
                      );
                      await mapController.getRoute(lat, lng).then((_) {
                        Navigator.pop(context);
                      });
                    },
                    polylines: mapController.currentRoute,
                    markers: mapController.markers,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
