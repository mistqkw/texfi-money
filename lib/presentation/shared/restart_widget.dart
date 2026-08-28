import 'package:flutter/material.dart';

/// Оборачивает поддерево уникальным [Key], который можно заменить, чтобы
/// Flutter полностью уничтожил и заново построил всё под ним — включая
/// [ProviderScope] и все провайдеры. Используется для «сброса приложения»:
/// без этого сброс БД/настроек не отразился бы на уже созданных провайдерах,
/// которые держат старое состояние в памяти.
class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?._restart();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void _restart() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
