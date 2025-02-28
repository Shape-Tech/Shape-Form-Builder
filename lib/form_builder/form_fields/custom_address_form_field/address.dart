import 'package:equatable/equatable.dart';

class Address extends Equatable {
  int? id;
  String addressLineOne;
  String? addressLineTwo;
  String? addressLineThree;
  String? addressLineFour;
  String city;
  String state;
  String zip;
  String? country;
  double? lat;
  double? long;

  Address({
    this.id,
    required this.addressLineOne,
    this.addressLineTwo,
    this.addressLineThree,
    this.addressLineFour,
    required this.city,
    required this.state,
    required this.zip,
    this.country,
    this.lat,
    this.long,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        id: json['id'],
        addressLineOne: json['address_line_one'],
        addressLineTwo: json['address_line_two'],
        addressLineThree: json['address_line_three'],
        addressLineFour: json['address_line_four'],
        city: json['city'],
        state: json['state'],
        zip: json['zip_code'],
        country: json["country"],
        lat: json['lat'],
        long: json['long']);
  }

  factory Address.fromPlaceJson(Map<String, dynamic> json) {
    String? streetNumber;
    String _lineOne = "";
    String? _lineTwo;
    String? _lineThree;
    String? _lineFour;
    String _city = "";
    String _state = "";
    String _zip = "";
    String? _country;

    List<PlaceComponent> addressComponents = List<PlaceComponent>.of(
        json["address_components"]
            .map<PlaceComponent>((c) => PlaceComponent.fromJson(c)));

    String? route;

    for (var component in addressComponents) {
      if (component.types.contains("street_number")) {
        streetNumber = component.longName;
      }
      if (component.types.contains("route")) {
        route = component.longName;
      }
      if (component.types.contains("postal_town")) {
        _city = component.longName;
      }
      if (component.types.contains("locality")) {
        _city = component.longName;
      }
      if (component.types.contains("administrative_area_level_1")) {
        _state = component.longName;
      }
      if (component.types.contains("postal_code")) {
        _zip = component.longName;
      }
      if (component.types.contains("country")) {
        _country = component.longName;
      }
    }

    _lineOne = "${streetNumber != null ? streetNumber + " " : ""}${route}";

    return Address(
      addressLineOne: _lineOne,
      addressLineTwo: _lineTwo,
      city: _city,
      state: _state,
      zip: _zip,
      country: _country,
    );
  }

  @override
  List<Object?> get props =>
      [addressLineOne, addressLineTwo, city, state, zip, country];

  toJson() {
    Map<String, dynamic> data = {};
    data["address_line_one"] = addressLineOne;
    data["address_line_two"] = addressLineTwo;
    data["city"] = city;
    data["state"] = state;
    data["zip"] = zip;
    data["country"] = country;

    return data;
  }

  @override
  String toString() {
    List<String> addressComponents = [];

    if (addressLineOne.trim().isNotEmpty) {
      addressComponents.add(addressLineOne);
    }

    if (addressLineTwo != null && addressLineTwo!.trim().isNotEmpty) {
      addressComponents.add(addressLineTwo!);
    }

    if (city.trim().isNotEmpty) {
      addressComponents.add(city);
    }

    if (state.trim().isNotEmpty) {
      addressComponents.add(state);
    }

    if (zip.trim().isNotEmpty) {
      addressComponents.add(zip);
    }

    if (country != null && country!.trim().isNotEmpty) {
      addressComponents.add(country!);
    }

    String includingNull = addressComponents.join(', ');
    return includingNull.replaceAll('null', '');
  }

  static fromV2Json(passedJson) {}
}

class PlaceComponent {
  String longName;
  String shortName;
  List<String> types;

  PlaceComponent(this.longName, this.shortName, this.types);

  factory PlaceComponent.fromJson(Map<String, dynamic> json) {
    List<dynamic> types = json["types"];
    List<String> typesAsString = [];
    for (var element in types) {
      typesAsString.add(element);
    }

    return PlaceComponent(
      json['long_name'],
      json['short_name'],
      typesAsString,
    );
  }
}
