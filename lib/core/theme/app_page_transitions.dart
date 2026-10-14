import 'package:flutter/material.dart';

import 'app_motion.dart';

/// Переход между экранами (дизайн «hairline»): плавное появление с лёгким
/// подъёмом на несколько пикселей. Без распада на блоки.
class HairPageTransitionsBuilder extends PageTransitionsBuilder {
  const HairPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return HairTransition(animation: animation, child: child);
  }
}

class HairTransition extends StatelessWidget {
  const HairTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeIn,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.025),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Маршрут с тем же переходом — для мест, где страницу открывают вручную.
PageRoute<T> hairRoute<T>(Widget page, {bool fullscreenDialog = false}) {
  return PageRouteBuilder<T>(
    fullscreenDialog: fullscreenDialog,
    transitionDuration: AppMotion.route,
    reverseTransitionDuration: AppMotion.route,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        HairTransition(animation: animation, child: child),
  );
}
