import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/repositories/google_maps_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class AddressFormField extends FormField<Address> {
  AddressFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<Address> onSaved,
    required FormFieldValidator<Address> validator,
    Address? initialValue,
    Address? originalValue,
    bool? disableDecoration,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<Address> state) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
                  decoration: disableDecoration == true
                      ? null
                      : BoxDecoration(
                          boxShadow: [
                              BoxShadow(
                                  color: const Color(0x4D1E1E1E),
                                  offset: Offset.zero,
                                  blurRadius: 5,
                                  spreadRadius: 0)
                            ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label),
                              const Spacer(),
                            ],
                          ),
                          if (labelDescription != null)
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text(labelDescription)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AddressFormFieldSearch(
                                validator: validator,
                                onAddressSelected: (selectedAddress) {
                                  state.setValue(selectedAddress);
                                  onSaved(selectedAddress);
                                },
                              ),
                              if (originalValue != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: AddressSelected(
                                      selectedAddress: originalValue),
                                ),
                              if (state.hasError == true)
                                Text(
                                  state.errorText!,
                                  style: TextStyle(color: Colors.red),
                                )
                            ],
                          ),
                        ]),
                  ),
                ),
              );
            });
}

class AddressFormFieldSearch extends StatefulWidget {
  String? Function(Address?)? validator;
  String? Function(Address?)? onAddressSelected;
  AddressFormFieldSearch(
      {Key? key, this.validator, required this.onAddressSelected})
      : super(key: key);

  @override
  State<AddressFormFieldSearch> createState() => _AddressFormFieldSearchState();
}

class _AddressFormFieldSearchState extends State<AddressFormFieldSearch> {
  final TextEditingController _controller = TextEditingController();
  Uuid uuid = const Uuid();
  String? _sessionToken;
  List<Suggestion> _placeList = [];
  Address? selectedAddress;
  bool enterAddressManually = false;

  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressCityController = TextEditingController();
  final TextEditingController _addressStateController = TextEditingController();
  final TextEditingController _addressZipController = TextEditingController();
  final TextEditingController _addressCountryController =
      TextEditingController();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    if (selectedAddress == null) {
      if (_isProcessing) {
        return Center(child: CircularProgressIndicator());
      } else if (enterAddressManually == false) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type your address here...",
                  focusColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.location_pin),
                ),
                onChanged: (value) {
                  if (_sessionToken == null) {
                    setState(() {
                      _sessionToken = uuid.v4();
                    });
                  }
                  getSuggestion(value);
                },
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeList[index].description),
                  onTap: () {
                    if (widget.onAddressSelected != null) {
                      setState(() {
                        _isProcessing = true;
                      });
                      getPlace(_placeList[index].placeId);
                    }
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  child: Text("Enter Address Manually"),
                  onPressed: () {
                    setState(() {
                      enterAddressManually = true;
                    });
                  }),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: TextFormField(
                controller: _addressOneController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Address Line 1",
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
              ),
            ),
            Container(
              child: TextFormField(
                controller: _addressCityController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Address City",
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
              ),
            ),
            Container(
              child: TextFormField(
                controller: _addressStateController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Address State",
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
              ),
            ),
            Container(
              child: TextFormField(
                controller: _addressZipController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Address Zip/Postal Code",
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
              ),
            ),
            Container(
              child: TextFormField(
                controller: _addressCountryController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Address Country",
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
              ),
            ),
            if (showSelectAddressButton(
                addressOne: _addressOneController.text.trim(),
                addressCity: _addressCityController.text.trim(),
                addressState: _addressStateController.text.trim(),
                addressZip: _addressZipController.text.trim(),
                addressCountry: _addressCountryController.text.trim()))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    child: Text("Select This Address"),
                    onPressed: () {
                      Address manualAddress = Address(
                        address1: _addressOneController.text.trim(),
                        city: _addressCityController.text.trim(),
                        state: _addressStateController.text.trim(),
                        zip: _addressZipController.text.trim(),
                        country: _addressCountryController.text.trim(),
                      );
                      widget.onAddressSelected!(manualAddress);
                      setState(() {
                        selectedAddress = manualAddress;
                      });
                    }),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                child: Text("Use Address Lookup"),
                onPressed: () {
                  setState(() {
                    enterAddressManually = false;
                  });
                },
              ),
            ),
          ],
        );
      }
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AddressSelected(selectedAddress: selectedAddress),
          ),
          ElevatedButton(
            child: Text("Change Address"),
            onPressed: () {
              widget.onAddressSelected!(null);
              setState(
                () {
                  selectedAddress = null;
                  enterAddressManually = false;
                },
              );
            },
          ),
        ],
      );
    }
  }

  bool showSelectAddressButton(
      {required String addressOne,
      required String addressCity,
      required String addressState,
      required String addressZip,
      required String addressCountry}) {
    if (addressOne.isEmpty ||
        addressCity.isEmpty ||
        addressState.isEmpty ||
        addressZip.isEmpty ||
        addressCountry.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  getSuggestion(String input) async {
    Dio client = Dio();
    GoogleMapsRepository mapsRepository = GoogleMapsRepository(client: client);
    List<Suggestion> suggestions = await mapsRepository.getSuggestions(input);
    setState(() {
      _placeList = suggestions;
    });
  }

  getPlace(String placeId) async {
    Dio client = Dio();
    GoogleMapsRepository mapsRepository = GoogleMapsRepository(client: client);
    Address place = await mapsRepository.getPlace(placeId);
    setState(() {
      widget.onAddressSelected!(place);
      selectedAddress = place;
      _isProcessing = false;
    });
  }
}

class AddressSelected extends StatelessWidget {
  const AddressSelected({
    Key? key,
    required this.selectedAddress,
  }) : super(key: key);

  final Address? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid, color: Colors.grey, width: 2),
          color: Colors.white,
          borderRadius: new BorderRadius.all(const Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedAddress!.address1),
            if (selectedAddress!.address2 != null)
              Text(selectedAddress!.address2!),
            Text(selectedAddress!.city),
            Text(selectedAddress!.state),
            Text(selectedAddress!.zip),
            Text(selectedAddress!.country ?? ""),
          ],
        ),
      ),
    );
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}