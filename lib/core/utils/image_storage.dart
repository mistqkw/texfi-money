import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Копирует выбранное фото в постоянную папку документов приложения —
/// путь, который отдаёт image_picker, может указывать на временный кэш,
/// не гарантированный к следующему запуску.
Future<String> savePickedImage(XFile picked) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory(p.join(docsDir.path, 'goal_images'));
  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }

  final ext = p.extension(picked.path);
  final destPath = p.join(imagesDir.path, '${_uuid.v4()}$ext');
  await File(picked.path).copy(destPath);
  return destPath;
}

/// Удаляет файл фото, если он существует — не бросает при отсутствии.
Future<void> deleteImageIfExists(String? path) async {
  if (path == null) return;
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
