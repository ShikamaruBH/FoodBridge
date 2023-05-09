import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/screens/neworupdatedonation.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:provider/provider.dart';

class ChooseLocationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final bool newScreen;
  // ignore: prefer_const_constructors_in_immutables
  ChooseLocationScreen(this.newScreen, {super.key});

  void next(context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!newScreen) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NewOrUpdateDonationScreen(null),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (_, localeController, __) => Scaffold(
            appBar: AppBar(
              title:
                  Text(localeController.getTranslate('choose-location-title')),
              leading: IconButton(
                  onPressed: () {
                    mapController.controller?.dispose();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
              actions: [
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const AutoCompleteTextField(),
                    );
                  },
                  icon: const Icon(Icons.search_rounded),
                  splashRadius: 20,
                )
              ],
            ),
            body: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: ChangeNotifierProvider.value(
                value: mapController,
                child: Consumer<MapController>(
                  builder: (__, mapController, _) => Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: mapController.currentLatLng,
                          zoom: 15,
                        ),
                        myLocationEnabled: true,
                        onMapCreated: (controller) {
                          mapController.controller = controller;
                        },
                        markers: mapController.markers,
                        onTap: (argument) async =>
                            mapController.addMarker(argument),
                      ),
                      Positioned(
                          bottom: 0,
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: Theme.of(context).colorScheme.primary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 25, top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        localeController.getTranslate(
                                            'choose-your-location-title'),
                                        style: StyleManagement.usernameTextStyle
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const CustomSpacerWidget(),
                                    FormBuilder(
                                      key: _formKey,
                                      child: FormBuilderTextField(
                                        name: 'address',
                                        readOnly: true,
                                        minLines: 1,
                                        maxLines: 2,
                                        controller: mapController
                                            .addressTextFieldController,
                                        style: StyleManagement.addressTextStyle,
                                        decoration: DecoratorManagement
                                            .addressTextFieldDecorator(
                                          'address-hint-text',
                                          Icon(
                                            Icons.location_on_sharp,
                                            color: ColorManagement
                                                .descriptionColorDark,
                                          ),
                                        ),
                                        validator: CustomValidator.required,
                                      ),
                                    ),
                                    const CustomSpacerWidget(),
                                    ElevatedButton(
                                      onPressed: mapController.isError &&
                                              mapController
                                                  .currentAddress.isEmpty
                                          ? null
                                          : () => next(context),
                                      style: StyleManagement.elevatedButtonStyle
                                          .copyWith(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                        elevation:
                                            const MaterialStatePropertyAll(4),
                                      ),
                                      child: Text(
                                        localeController
                                            .getTranslate('next-button-title'),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
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

class AutoCompleteTextField extends StatelessWidget {
  const AutoCompleteTextField({
    super.key,
  });

  void addMarker(context, suggestion) {
    final coordinate = suggestion.geometry.coordinates[0][0];
    mapController.addMarker(LatLng(
      coordinate.latitude,
      coordinate.longitude,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  decoration: DecoratorManagement.defaultTextFieldDecoratorDark,
                ),
                suggestionsCallback: (pattern) =>
                    mapController.getSuggestion(pattern),
                itemBuilder: (context, suggestion) =>
                    AddressListTitle(suggestion),
                onSuggestionSelected: (suggestion) =>
                    addMarker(context, suggestion),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AddressListTitle extends StatelessWidget {
  final GeoJsonFeature suggestion;
  const AddressListTitle(
    this.suggestion, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            Icons.location_on_sharp,
            size: 25,
            color: ColorManagement.iconColor,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            suggestion.properties['label'],
            style: StyleManagement.historyItemTitleTextStyle.copyWith(
              color: ColorManagement.titleColorDark,
            ),
          ),
        )
      ],
    );
  }
}
