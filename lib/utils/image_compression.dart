import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class ImageCompression {
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int maxWidth = 1024;
  static const int maxHeight = 1024;
  static const int defaultQuality = 85;

  /// Compresses an XFile image to reduce file size for upload
  static Future<File> compressImage(XFile imageFile) async {
    print("📸 Original image path: ${imageFile.path}");
    
    // Read the original file
    final File originalFile = File(imageFile.path);
    final Uint8List originalBytes = await originalFile.readAsBytes();
    final int originalSize = originalBytes.length;
    
    print("📸 Original file size: ${_formatFileSize(originalSize)}");
    
    // If file is already small enough, return it as-is
    if (originalSize <= maxFileSizeBytes) {
      print("📸 File already within size limit, no compression needed");
      return originalFile;
    }
    
    // Decode the image
    img.Image? originalImage = img.decodeImage(originalBytes);
    if (originalImage == null) {
      print("❌ Failed to decode image, returning original");
      return originalFile;
    }
    
    print("📸 Original dimensions: ${originalImage.width}x${originalImage.height}");
    
    // Resize if necessary
    img.Image resizedImage = originalImage;
    if (originalImage.width > maxWidth || originalImage.height > maxHeight) {
      resizedImage = img.copyResize(
        originalImage,
        width: originalImage.width > originalImage.height ? maxWidth : null,
        height: originalImage.height > originalImage.width ? maxHeight : null,
        maintainAspect: true,
      );
      print("📸 Resized dimensions: ${resizedImage.width}x${resizedImage.height}");
    }
    
    // Start with default quality and reduce if needed
    int quality = defaultQuality;
    Uint8List compressedBytes;
    
    do {
      compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: quality),
      );
      print("📸 Compressed size at quality $quality: ${_formatFileSize(compressedBytes.length)}");
      
      if (compressedBytes.length <= maxFileSizeBytes || quality <= 20) {
        break;
      }
      
      quality -= 10;
    } while (quality > 20);
    
    // Create compressed file
    final String compressedPath = imageFile.path.replaceAll('.jpg', '_compressed.jpg');
    final File compressedFile = File(compressedPath);
    await compressedFile.writeAsBytes(compressedBytes);
    
    final double compressionRatio = (1 - (compressedBytes.length / originalSize)) * 100;
    print("📸 Final compressed size: ${_formatFileSize(compressedBytes.length)}");
    print("📸 Compression ratio: ${compressionRatio.toStringAsFixed(1)}%");
    
    return compressedFile;
  }
  
  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
