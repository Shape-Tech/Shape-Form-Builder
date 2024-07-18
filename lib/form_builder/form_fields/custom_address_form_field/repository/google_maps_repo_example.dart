import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/repository/google_maps_repo.dart';

class GoogleMapsRepoExample extends GoogleMapsRepo {
  @override
  Future<LatLng> getCoordinates(String placeId) async {
    await Future.delayed(Duration(seconds: 1));
    return LatLng(3271.43, 1194.345);
  }

  @override
  Future<Address> getPlace(String placeId) async {
    await Future.delayed(Duration(seconds: 2));
    if (placeId == "001") {
      return Address(
          addressLineOne: "7 Theresa Mews",
          city: "Port Elliotstad",
          state: "Port Justineton",
          zip: "RG14 2EL",
          country: "United Kingdom");
    } else {
      throw "Could not find address";
    }
  }

  @override
  Future<List<Suggestion>> getSuggestions(String? input) async {
    List<Suggestion> suggestions = [
      Suggestion("001", "7 Theresa Mews"),
      Suggestion("002", "65 Main Street"),
      Suggestion("003", "101 Nwe York Place"),
    ];
    await Future.delayed(Duration(seconds: 2));
    return suggestions
        .where((suggestion) =>
            suggestion.description.toLowerCase().contains(input ?? ""))
        .toList();
  }
}
