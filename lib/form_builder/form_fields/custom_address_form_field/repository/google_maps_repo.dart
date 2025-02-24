import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';

abstract class MapsRepo {
  Future<List<Suggestion>> getSuggestions(String? input);

  Future<Address> getPlace(String placeId);
}
