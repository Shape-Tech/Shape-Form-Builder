import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/custom_dropzone_view.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/file_data_model.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/repository/image_repo.dart';

class ImageFormField extends FormField<Uint8List> {
  ImageFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<Uint8List> onSaved,
    required FormFieldValidator<Uint8List> validator,
    Uint8List? initialValue,
    Uint8List? originalValue,
    bool? disableDecoration,
    // ImageRepo? imageRepo,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<Uint8List> state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
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
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(labelDescription)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (state.value == null)
                                    CustomDropzoneView(
                                      width: double.infinity,
                                      height: 300,
                                      onSaved: (newFile) {
                                        state.didChange(newFile);
                                        onSaved(newFile);
                                      },
                                    ).verticalPadding(20),
                                  if (state.value != null)
                                    LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Image.memory(
                                          state.value!,
                                          width: constraints.maxWidth > 600
                                              ? constraints.maxWidth / 2
                                              : constraints.maxWidth,
                                          height: constraints.maxWidth > 600
                                              ? constraints.maxWidth / 3
                                              : constraints.maxWidth / 2,
                                          fit: BoxFit.contain,
                                        ),
                                      ).verticalPadding(20);
                                    }),
                                  ElevatedButton(
                                    onPressed: () async {
                                      debugPrint("Clicked button");
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();
                                      PlatformFile? file;
                                      if (result != null) {
                                        try {
                                          file = result.files.firstOrNull;
                                        } catch (e) {
                                          throw "Error getting file";
                                        }
                                      } else {
                                        // User canceled the picker
                                      }

                                      if (result != null &&
                                          file != null &&
                                          file.bytes != null) {
                                        Uint8List fileBytes = file.bytes!;

                                        state.didChange(fileBytes);
                                        onSaved(fileBytes);
                                      }
                                    },
                                    child: Text(state.value == null
                                        ? 'Pick Image'
                                        : "Replace Image"),
                                  ),
                                ],
                              ),
                            ),
                            if (originalValue != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Image.memory(originalValue),
                              ),
                            if (state.hasError == true)
                              Text(
                                state.errorText!,
                                style: const TextStyle(color: Colors.red),
                              )
                          ],
                        ),
                      ]),
                ),
              );
            });
}
