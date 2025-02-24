import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/repository/google_maps_repo.dart';

// This uses the geoapify.com API to get suggestions and place details.
class NewMapsRepository extends MapsRepo {
  Dio client = Dio();

  static const String apiKey = String.fromEnvironment('API_KEY');

  @override
  Future<List<Suggestion>> getSuggestions(String? input) async {
    if (input != null) {
      try {
        final url = 'https://api.geoapify.com/v1/geocode/autocomplete';

        final queryParams = {'text': input, 'apiKey': apiKey};

        var dioResponse = await client.get(url, queryParameters: queryParams);
        if (dioResponse.statusCode == 200) {
          final jsonResponse = dioResponse.data;
          List<Suggestion> suggestions = List<Suggestion>.of(
            jsonResponse['features'].map<Suggestion>((json) {
              final properties = json['properties'];
              final address = Address(
                addressLineOne: properties['address_line1'] ?? '',
                city: properties['city'] ?? '',
                state: properties['state'] ?? '',
                country: properties['country'] ?? '',
                zip: properties['postcode'] ?? '',
              );
              return Suggestion(
                placeId: properties['place_id'].toString(),
                description: properties['formatted'],
                address: address,
              );
            }),
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

  @override
  Future<Address> getPlace(String placeId) {
    // TODO: implement getPlace
    throw UnimplementedError();
  }

  // Future<Address> getPlace(String placeId) async {
  //   try {
  //     final url = endpoint + '/maps/place';

  //     String queryString = "?query=" + placeId;

  //     String requestUrl = url + queryString;

  //     var dioResponse = await client.get(requestUrl);
  //     if (dioResponse.statusCode == 200) {
  //       final jsonResponse = json.decode(dioResponse.data);
  //       Address place = Address.fromPlaceJson(jsonResponse["result"]);
  //       return place;
  //     } else {
  //       throw "Status code error: " + dioResponse.statusCode.toString();
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<LatLng> getCoordinates(String placeId) async {
  //   try {
  //     final url = endpoint + '/maps/place';

  //     String queryString = "?query=" + placeId;

  //     String requestUrl = url + queryString;

  //     var dioResponse = await client.get(requestUrl);
  //     if (dioResponse.statusCode == 200) {
  //       final jsonResponse = json.decode(dioResponse.data);
  //       final jsonLocation = jsonResponse['result']['geometry']['location'];
  //       LatLng coordinates = LatLng(jsonLocation['lat'], jsonLocation['lng']);
  //       return coordinates;
  //     } else {
  //       throw "Status code error: " + dioResponse.statusCode.toString();
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
