import 'package:file_picker/file_picker.dart';
import 'dart:io';

class VideoPickerService {
  Future<(File?, String?)> pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return (null, 'No video selected');
      }

      final PlatformFile file = result.files.first;

      // Check if file has path (not null on mobile/desktop)
      if (file.path == null) {
        return (null, 'Could not access video path');
      }

      final File videoFile = File(file.path!);

      // Validate file size (example: 100MB limit)
      final double fileSizeInMB = file.size / (1024 * 1024);
      if (fileSizeInMB > 100) {
        return (null, 'Video size must be less than 100MB');
      }

      // Validate format
      final String extension = file.extension?.toLowerCase() ?? '';
      final validFormats = ['mp4', 'mov', 'avi'];
      if (!validFormats.contains(extension)) {
        return (
          null,
          'Invalid video format. Supported formats: ${validFormats.join(", ")}'
        );
      }

      return (videoFile, null);
    } catch (e) {
      return (null, 'Error picking video: $e');
    }
  }

  // Example usage in repository or bloc
}
