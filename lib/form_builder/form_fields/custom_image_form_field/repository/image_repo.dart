import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';

abstract class ImageRepo {
  Future<Uint8List> uploadImage({
    required String bucketId,
    required Uint8List imageToUpload,
    required String filePath,
  });
}
