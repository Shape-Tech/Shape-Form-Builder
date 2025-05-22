import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/custom_dropzone_view.dart';
import 'package:shape_form_builder/form_builder/models/optional_required_chip.dart';
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
    OptionalRequiredChip? optionalRequiredChip,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label,
                                maxLines: 4, overflow: TextOverflow.ellipsis),
                            if (labelDescription != null) ...[
                              Gap(spacing),
                              Text(labelDescription,
                                  maxLines: 4, overflow: TextOverflow.ellipsis),
                            ],
                          ],
                        ),
                      ),
                      Gap(styling?.spacingMedium ?? padding),
                      if (optionalRequiredChip != null &&
                          optionalRequiredChip.showChip == true) ...[
                        optionalRequiredChip.getChip(styling),
                      ],
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Gap(spacing),
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
                            ),
                          Gap(spacing),
                          if (state.value != null) ...[
                            LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return Image.memory(
                                state.value!.bytes!,
                                width: constraints.maxWidth > 600
                                    ? constraints.maxWidth / 2
                                    : constraints.maxWidth,
                                height: constraints.maxWidth > 600
                                    ? constraints.maxWidth / 3
                                    : constraints.maxWidth / 2,
                                fit: BoxFit.contain,
                              );
                            }),
                            Gap(spacing),
                          ],
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
                      if (originalValue != null) ...[
                        Gap(spacing),
                        Image.memory(originalValue!.bytes!),
                      ],
                      if (state.hasError == true) ...[
                        Gap(spacing),
                        Text(
                          state.errorText!,
                          style: TextStyle(color: styling?.error ?? Colors.red),
                        )
                      ],
                    ],
                  ),
                ],
              ).allPadding(styling?.spacingMedium ?? padding),
            );
          },
        );
}
