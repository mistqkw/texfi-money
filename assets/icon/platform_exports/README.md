# Иконка — экспорты для платформ без Flutter-таргета

Этот репозиторий сейчас настроен **только под Android**
(нет папок `ios/`, `macos/`, `windows/`, `linux/`) — `flutter_launcher_icons`
генерирует реальные иконки приложения только для Android
(`android/app/src/main/res/mipmap-*`), см. `pubspec.yaml`.

Файлы здесь — готовые статические экспорты из того же исходника
(`../app_icon.png`, 1024×1024, полноразмерный вариант без adaptive-слоя)
на случай, если позже появятся соответствующие платформы:

- `app_icon.ico` — Windows, размеры 16/32/48/256px в одном файле.
- `linux/icon_16.png` … `icon_512.png` — Linux, отдельные PNG 16–512px.
- Для iOS/macOS `AppIcon.appiconset` отдельный экспорт не нужен: как только
  появится `ios/`/`macos/` (например, после `flutter create --platforms=ios,macos .`),
  `flutter_launcher_icons` сгенерирует полный набор сам из `../app_icon.png` —
  просто добавь `ios: true` / `macos: true` в блок `flutter_launcher_icons:`
  в `pubspec.yaml` и запусти генератор.

Ни один из этих файлов пока никуда не подключён (не может быть — платформы
нет), это просто готовые ассеты про запас.
