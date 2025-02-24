import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'dart:typed_data';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/file_data_model.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomDropzoneView extends StatefulWidget {
  CustomDropzoneView({
    super.key,
    required this.onSaved,
    required this.height,
    required this.width,
    this.styling,
  });

  Function(FileDataModel) onSaved;
  double width;
  double height;
  ShapeFormStyling? styling;

  @override
  State<CustomDropzoneView> createState() => _CustomDropzoneViewState();
}

class _CustomDropzoneViewState extends State<CustomDropzoneView> {
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
          name: name, mime: mime, bytes: byte, path: url, data: data);
    } else {
      throw "Could not get file data";
    }
  }

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isHovering == false
                  ? Colors.white
                  : (widget.styling?.secondaryLight ?? Colors.grey[100]),
              border: Border.all(
                  color: widget.styling?.border ?? Colors.grey[200]!, width: 1),
              borderRadius: BorderRadius.circular(
                  widget.styling?.borderRadiusMedium ?? 10),
            ),
            child: DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (DropzoneViewController ctrl) {
                controller = ctrl;
              },
              onLoaded: () => print('Zone loaded'),
              onError: (String? ev) => print('Error: $ev'),
              onHover: () {
                print('Zone hovered');

                setState(() {
                  isHovering = true;
                });
              },
              onDrop: (dynamic ev) {
                UploadedFile(ev).then((FileDataModel file) {
                  // Uint8List fileBytes = file.data;
                  widget.onSaved(file);
                });
              },
              onLeave: () => print('Zone left'),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 80,
                  color: widget.styling?.primary ?? FormColors.primary,
                ),
                Text(
                  'Drop Files Here',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
