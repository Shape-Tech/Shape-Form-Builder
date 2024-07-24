import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
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
              DropzoneViewController? controller;

              Future<FileDataModel> UploadedFile(dynamic event) async {
                final name = event.name;
                if (controller != null) {
                  final mime = await controller!.getFileMIME(event);
                  final byte = await controller!.getFileSize(event);
                  final url = await controller!.createFileUrl(event);
                  final data = await controller!.getFileData(event);

                  debugPrint('Name : $name');
                  debugPrint('Mime: $mime');
                  debugPrint('Size : ${byte / (1024 * 1024)}');
                  debugPrint('URL: $url');

                  return FileDataModel(
                      name: name,
                      mime: mime,
                      bytes: byte,
                      path: url,
                      data: data);
                } else {
                  throw "Could not get file data";
                }
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text(labelDescription)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 300,
                                child: Stack(
                                  children: [
                                    if (state.value == null)
                                      DropzoneView(
                                        operation: DragOperation.copy,
                                        cursor: CursorType.grab,
                                        onCreated:
                                            (DropzoneViewController ctrl) {
                                          controller = ctrl;
                                        },
                                        onLoaded: () => print('Zone loaded'),
                                        onError: (String? ev) =>
                                            print('Error: $ev'),
                                        onHover: () => print('Zone hovered'),
                                        onDrop: (dynamic ev) {
                                          UploadedFile(ev)
                                              .then((FileDataModel file) {
                                            Uint8List fileBytes = file.data;

                                            state.didChange(fileBytes);
                                            onSaved(fileBytes);
                                          });
                                        },
                                        onLeave: () => print('Zone left'),
                                      ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (state.value == null) ...[
                                            const Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 80,
                                              color: Color(0xFF5F6A86),
                                            ),
                                            const Text(
                                              'Drop Files Here',
                                              style: TextStyle(
                                                  color: Color(0xFF5F6A86),
                                                  fontSize: 24),
                                            ),
                                          ],
                                          if (state.value != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Image.memory(
                                                state.value!,
                                                width: 150,
                                                height: 100,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              debugPrint("Clicked button");
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();
                                              PlatformFile? file;
                                              if (result != null) {
                                                try {
                                                  file =
                                                      result.files.firstOrNull;
                                                } catch (e) {
                                                  throw "Error getting file";
                                                }
                                              } else {
                                                // User canceled the picker
                                              }

                                              if (result != null &&
                                                  file != null &&
                                                  file.bytes != null) {
                                                Uint8List fileBytes =
                                                    file.bytes!;

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
                ),
              );
            });
}
