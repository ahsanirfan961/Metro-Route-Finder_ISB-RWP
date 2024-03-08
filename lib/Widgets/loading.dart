// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WidgetWithLoading extends StatefulWidget {
  final Widget child;

  const WidgetWithLoading({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _WidgetWithLoadingState();
}

class _WidgetWithLoadingState extends State<WidgetWithLoading> {
  Widget loadingWidget = const Text('');

  void startLoading() {
    loadingWidget = Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
              color: Colors.deepOrangeAccent.shade700, size: 50)),
    );
    setState(() {});
  }

  void stopLoading() {
    loadingWidget = const Text('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => LoadingWidget(
        animation: loadingWidget,
        state: this,
        child: widget.child,
      );
}

class LoadingWidget extends InheritedWidget {
  final Widget animation;
  final _WidgetWithLoadingState state;

  const LoadingWidget(
      {super.key,
      required this.animation,
      required super.child,
      required this.state});

  @override
  bool updateShouldNotify(covariant LoadingWidget oldWidget) {
    return oldWidget.animation != animation;
  }

  static _WidgetWithLoadingState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LoadingWidget>()!.state;
}
