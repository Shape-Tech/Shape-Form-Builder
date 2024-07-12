import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';

class GoogleMapsRepository {
  Dio client;
  GoogleMapsRepository({required this.client});

  String endpoint = String.fromEnvironment('API_ENDPOINT');
  Future<List<Suggestion>> getSuggestions(String? input) async {
    if (input != null) {
      try {
        final url = endpoint + '/maps/autocomplete';

        String queryString = "?query=" + input;

        String requestUrl = url + queryString;

        var dioResponse = await client.get(requestUrl);
        if (dioResponse.statusCode == 200) {
          final jsonResponse = json.decode(dioResponse.data);
          List<Suggestion> suggestions = List<Suggestion>.of(
            jsonResponse['predictions'].map<Suggestion>(
              (json) =>
                  Suggestion(json['place_id'].toString(), json['description']),
            ),
          );
          return suggestions;
        } else {
          throw "Status code error: " + dioResponse.statusCode.toString();
        }
      } catch (e) {
        rethrow;
      }
    } else {
      return [];
    }
  }

  Future<Address> getPlace(String placeId) async {
    try {
      final url = endpoint + '/maps/place';

      String queryString = "?query=" + placeId;

      String requestUrl = url + queryString;

      var dioResponse = await client.get(requestUrl);
      if (dioResponse.statusCode == 200) {
        final jsonResponse = json.decode(dioResponse.data);
        Address place = Address.fromPlaceJson(jsonResponse["result"]);
        return place;
      } else {
        throw "Status code error: " + dioResponse.statusCode.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LatLng> getCoordinates(String placeId) async {
    try {
      final url = endpoint + '/maps/place';

      String queryString = "?query=" + placeId;

      String requestUrl = url + queryString;

      var dioResponse = await client.get(requestUrl);
      if (dioResponse.statusCode == 200) {
        final jsonResponse = json.decode(dioResponse.data);
        final jsonLocation = jsonResponse['result']['geometry']['location'];
        LatLng coordinates = LatLng(jsonLocation['lat'], jsonLocation['lng']);
        return coordinates;
      } else {
        throw "Status code error: " + dioResponse.statusCode.toString();
      }
    } catch (e) {
      rethrow;
    }
  }
}
