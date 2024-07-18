import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';

abstract class GoogleMapsRepo {
  Future<List<Suggestion>> getSuggestions(String? input);

  Future<Address> getPlace(String placeId);

  Future<LatLng> getCoordinates(String placeId);
}
