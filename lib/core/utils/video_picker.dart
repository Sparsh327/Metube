import 'package:file_picker/file_picker.dart';
import 'package:get_thumbnail_video/index.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

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

  Future<(File?, String?)> getVideoThumbnail(File videoFile) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(uint8list);
      final thumbnail = File(file.path);
      return (thumbnail, null);
    } catch (e) {
      return (null, 'Error getting video thumbnail: $e');
    }
  }
}
