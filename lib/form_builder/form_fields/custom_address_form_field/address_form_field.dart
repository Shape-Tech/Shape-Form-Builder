import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/repository/google_maps_repo.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_text_field/custom_text_form_field.dart';
import 'package:shape_form_builder/form_builder/models/optional_required_chip.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';
import 'package:shape_form_builder/repositories/new_maps_repository.dart';
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
    MapsRepo? mapsRepo,
    ShapeFormStyling? styling,
    OptionalRequiredChip? optionalRequiredChip,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<Address> state) {
              return Container(
                decoration: styling?.containerDecoration ??
                    BoxDecoration(
                      color: styling?.background ?? Colors.white,
                      border: Border.all(
                          color: styling?.border ?? Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 10),
                    ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(label,
                                    style: styling?.bodyTextBoldStyle,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis),
                                if (labelDescription != null) ...[
                                  Gap(spacing),
                                  Text(labelDescription,
                                      style: styling?.bodyTextStyle),
                                ],
                              ],
                            ),
                          ),
                          const Gap(spacing),
                          if (optionalRequiredChip != null &&
                              optionalRequiredChip.showChip == true) ...[
                            if (optionalRequiredChip.showChip) ...[
                              optionalRequiredChip.getChip(styling),
                            ],
                          ],
                        ],
                      ),
                      Gap(spacing),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: styling?.spacingMedium ?? 10,
                        children: [
                          AddressFormFieldSearch(
                            validator: validator,
                            onAddressSelected: (selectedAddress) {
                              state.setValue(selectedAddress);
                              onSaved(selectedAddress);
                            },
                            mapsRepo: mapsRepo,
                            styling: styling,
                            initialValue: initialValue,
                          ),
                          if (originalValue != null) ...[
                            Text("Originally Selected Address",
                                style: styling?.captionStyle),
                            AddressSelected(selectedAddress: originalValue),
                          ],
                          if (state.hasError == true) ...[
                            Gap(spacing),
                            Text(
                              state.errorText!,
                              style: TextStyle(
                                  color: styling?.error ?? Colors.red),
                            )
                          ],
                        ],
                      ),
                    ]).allPadding(styling?.spacingMedium ?? padding),
              );
            });
}

class AddressFormFieldSearch extends StatefulWidget {
  String? Function(Address?)? validator;
  String? Function(Address?)? onAddressSelected;
  MapsRepo? mapsRepo;
  ShapeFormStyling? styling;
  Address? initialValue;
  AddressFormFieldSearch({
    Key? key,
    this.validator,
    required this.onAddressSelected,
    this.mapsRepo,
    this.styling,
    this.initialValue,
  }) : super(key: key);

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
  void initState() {
    super.initState();
    selectedAddress = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedAddress == null) {
      if (_isProcessing) {
        return Center(child: CircularProgressIndicator());
      } else if (enterAddressManually == false && widget.mapsRepo != null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              textfieldController: _controller,
              hintText: "Type your address here...",
              onChanged: (value) {
                if (_sessionToken == null) {
                  setState(() {
                    _sessionToken = uuid.v4();
                  });
                }
                getSuggestion(value);
              },
              styling: widget.styling,
              showOuterContainer: false,
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

                      getPlace(_placeList[index]);
                    }
                  },
                );
              },
            ),
            Gap(spacing),
            ElevatedButton(
                style: widget.styling?.secondaryButtonStyle ??
                    FormButtonStyles.secondaryButton,
                child: Center(child: Text("Enter Address Manually")),
                onPressed: () {
                  setState(() {
                    enterAddressManually = true;
                  });
                }),
          ],
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: CustomTextFormField(
                textfieldController: _addressOneController,
                hintText: "Address Line 1",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                styling: widget.styling,
                showOuterContainer: false,
              ),
            ),
            Gap(spacing),
            Container(
              child: CustomTextFormField(
                textfieldController: _addressCityController,
                hintText: "Address City",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                styling: widget.styling,
                showOuterContainer: false,
              ),
            ),
            Gap(spacing),
            Container(
              child: CustomTextFormField(
                textfieldController: _addressStateController,
                hintText: "Address State",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                styling: widget.styling,
                showOuterContainer: false,
              ),
            ),
            Gap(spacing),
            Container(
              child: CustomTextFormField(
                textfieldController: _addressZipController,
                hintText: "Address Zip/Postal Code",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                styling: widget.styling,
                showOuterContainer: false,
              ),
            ),
            Gap(spacing),
            Container(
              child: CustomTextFormField(
                textfieldController: _addressCountryController,
                hintText: "Address Country",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                styling: widget.styling,
                showOuterContainer: false,
              ),
            ),
            Gap(spacing),
            if (showSelectAddressButton(
                addressOne: _addressOneController.text.trim(),
                addressCity: _addressCityController.text.trim(),
                addressState: _addressStateController.text.trim(),
                addressZip: _addressZipController.text.trim(),
                addressCountry: _addressCountryController.text.trim())) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text("Select This Address"),
                      onPressed: () {
                        Address manualAddress = Address(
                          addressLineOne: _addressOneController.text.trim(),
                          city: _addressCityController.text.trim(),
                          state: _addressStateController.text.trim(),
                          zip: _addressZipController.text.trim(),
                          country: _addressCountryController.text.trim(),
                        );
                        widget.onAddressSelected!(manualAddress);
                        setState(() {
                          selectedAddress = manualAddress;
                        });
                      },
                      style: widget.styling?.primaryButtonStyle ??
                          FormButtonStyles.primaryButton,
                    ),
                  ),
                ],
              ),
            ],
            if (widget.mapsRepo != null) ...[
              Gap(spacing),
              TextButton(
                style: widget.styling?.outlinedButtonStyle ??
                    FormButtonStyles.outlinedButton,
                child: Center(child: Text("Use Address Lookup")),
                onPressed: () {
                  setState(() {
                    enterAddressManually = false;
                  });
                },
              ),
            ],
          ],
        );
      }
    } else {
      return Column(
        children: [
          AddressSelected(
            selectedAddress: selectedAddress,
            styling: widget.styling,
          ),
          Gap(spacing),
          ElevatedButton(
            style: widget.styling?.secondaryButtonStyle ??
                FormButtonStyles.secondaryButton,
            child: Center(child: Text("Change Address")),
            onPressed: () {
              widget.onAddressSelected!(null);
              setState(
                () {
                  selectedAddress = null;
                  enterAddressManually = false;
                  _isProcessing = false;
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
    List<Suggestion> suggestions = await widget.mapsRepo!.getSuggestions(input);
    setState(() {
      _placeList = suggestions;
    });
  }

  getPlace(Suggestion suggestion) async {
    if (suggestion.address == null) {
      Address place = await widget.mapsRepo!.getPlace(suggestion.placeId);
      _isProcessing = false;
      setState(() {
        widget.onAddressSelected!(place);
        selectedAddress = place;
      });
    } else {
      setState(() {
        widget.onAddressSelected!(suggestion.address);
        selectedAddress = suggestion.address;
      });
    }
  }
}

class AddressSelected extends StatelessWidget {
  const AddressSelected({
    Key? key,
    required this.selectedAddress,
    this.styling,
  }) : super(key: key);

  final Address? selectedAddress;
  final ShapeFormStyling? styling;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: styling?.containerDecoration ??
          BoxDecoration(
            color: styling?.background ?? Colors.white,
            border: Border.all(
              color: styling?.border ?? Colors.grey,
              width: 1,
            ),
            borderRadius:
                BorderRadius.circular(styling?.borderRadiusMedium ?? 10),
          ),
      child: Padding(
        padding: EdgeInsets.all(styling?.spacingMedium ?? 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedAddress!.addressLineOne),
            if (selectedAddress!.addressLineTwo != null)
              Text(selectedAddress!.addressLineTwo!),
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
  final Address? address;

  Suggestion({required this.placeId, required this.description, this.address});

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
