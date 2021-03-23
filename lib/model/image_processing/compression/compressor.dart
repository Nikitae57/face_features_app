import 'dart:io';

import 'package:face_features/model/image_processing/compression/compression_params.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

class Compressor {

  static const String JPG_EXTENSION = '.jpg';
  static const String JPEG_EXTENSION = '.jpeg';
  static const String PNG_EXTENSION = '.png';
  static const String HEIC_EXTENSION = '.heic';
  static const String WEBP_EXTENSION = '.webp';

  static const List<String> SUPPORTED_EXTENSIONS = <String>[
    JPG_EXTENSION, JPEG_EXTENSION, PNG_EXTENSION, HEIC_EXTENSION, WEBP_EXTENSION
  ];

  static Future<void> compressImageFile(CompressionParams params) {
    return _compressImageFile(params);
    // return compute<CompressionParams, void>(_compressImageFile, params);
  }

  static Future<void> _compressImageFile(CompressionParams params) async {
    final String sourcePath = params.sourcePath;
    final String targetPath = params.targetPath;
    final int quality = params.quality;

    final File sourceFile = File(sourcePath);
    if (!sourceFile.existsSync()) {
      throw ArgumentError('File $sourcePath does not exist');
    }

    final CompressFormat format = _imagePathToCompressFormat(sourcePath);
    final File? compressedFile = await FlutterImageCompress.compressAndGetFile(
        sourcePath, targetPath, quality: quality, format: format
    );

    if (compressedFile == null) {
      throw Exception('Failed to compress image: $sourcePath');
    }
  }

  static CompressFormat _imagePathToCompressFormat(String imagePath) {
    final String extension = p.extension(imagePath).toLowerCase();
    if (!SUPPORTED_EXTENSIONS.contains(extension)) {
      throw ArgumentError('Unsupported image format $imagePath}');
    }

    const Map<String, CompressFormat> extensionToFormat = <String, CompressFormat>{
      JPG_EXTENSION: CompressFormat.jpeg,
      JPEG_EXTENSION: CompressFormat.jpeg,
      PNG_EXTENSION: CompressFormat.png,
      HEIC_EXTENSION: CompressFormat.heic,
      WEBP_EXTENSION: CompressFormat.webp,
    };

    return extensionToFormat[extension]!;
  }
}
