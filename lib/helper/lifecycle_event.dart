import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback onResumed;

  LifecycleEventHandler({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
