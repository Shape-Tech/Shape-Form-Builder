import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/repository/image_repo.dart';
import 'package:supabase/supabase.dart';

class ImageRepoExample extends ImageRepo {
  static const String supabaseUrl = String.fromEnvironment("SUPABASEURL");
  static const String supabaseKey = String.fromEnvironment("SUPABASEKEY");

  @override
  Future<String> uploadImage({
    required String bucketId,
    required Uint8List imageToUpload,
    required String filePath,
  }) async {
    try {
      final supabase = SupabaseClient(
        supabaseUrl,
        supabaseKey,
      );

      supabase.auth.signInAnonymously();
      // try getting bucket id
      Bucket? bucket;
      try {
        bucket = await supabase.storage.getBucket(bucketId);
      } catch (e) {
        debugPrint("Bucket ${bucketId} does not exist. Error: ${e.toString()}");
      }

      // if it does not exist create the bucket
      if (bucket == null) {
        try {
          final String createdBucketId =
              await supabase.storage.createBucket(bucketId);
        } catch (e) {
          throw "Error creating the bucket";
        }

        try {
          bucket = await supabase.storage.getBucket(bucketId);
        } catch (e) {
          throw "Bucket ${bucketId} cannot be found after being created";
        }
      }

      // upload the file
      String? fullPath;
      try {
        final Uint8List imageFile = imageToUpload;
        fullPath = await supabase.storage.from(bucketId).uploadBinary(
              filePath,
              imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );
      } catch (e) {
        throw "Error while uploading file";
      }

      // download the file
      Uint8List? downloadedFile;
      try {
        downloadedFile =
            await supabase.storage.from(bucketId).download(fullPath);
      } catch (e) {
        throw "Could not download uploaded file";
      }

      // return the file
      try {
        return await supabase.storage.from(bucketId).getPublicUrl(fullPath);
      } catch (e) {
        throw "Could not get the public url";
      }
    } catch (e) {
      debugPrint(e.toString());
      throw e;
    }
  }
}
