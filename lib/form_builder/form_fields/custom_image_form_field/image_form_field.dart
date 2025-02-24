import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/custom_dropzone_view.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class ImageFormField extends FormField<PlatformFile> {
  ImageFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<PlatformFile> onSaved,
    required FormFieldValidator<PlatformFile> validator,
    PlatformFile? initialValue,
    PlatformFile? originalValue,
    bool? disableDecoration,
    ShapeFormStyling? styling,
    // ImageRepo? imageRepo,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<PlatformFile> state) {
              return Container(
                decoration: styling?.containerDecoration ??
                    BoxDecoration(
                      color: styling?.background ?? Colors.white,
                      border: Border.all(
                          color: styling?.border ?? Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 10),
                    ),
                child: Padding(
                  padding: EdgeInsets.all(styling?.spacingMedium ?? 20.0),
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
                                        PlatformFile file = PlatformFile(
                                          name: newFile.name,
                                          size: newFile.bytes,
                                          bytes: newFile.data,
                                        );
                                        state.didChange(file);
                                        onSaved(file);
                                      },
                                      styling: styling,
                                    ).verticalPadding(20),
                                  if (state.value != null)
                                    LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Image.memory(
                                          state.value!.bytes!,
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
                                        // Uint8List fileBytes = file.bytes!;

                                        state.didChange(file);
                                        onSaved(file);
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(state.value == null
                                            ? 'Pick Image'
                                            : "Replace Image"),
                                      ),
                                    ),
                                    style: styling?.secondaryButtonStyle ??
                                        FormButtonStyles.secondaryButton,
                                  ),
                                ],
                              ),
                            ),
                            if (originalValue != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Image.memory(originalValue!.bytes!),
                              ),
                            if (state.hasError == true)
                              Text(
                                state.errorText!,
                                style: TextStyle(
                                    color: styling?.error ?? Colors.red),
                              )
                          ],
                        ),
                      ]),
                ),
              );
            });
}
