// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class FutureBuilderCommmon<T> extends StatelessWidget {
  Future<T> future;
  Widget Function(T datas) child;
  Widget? errorWidget;
  Widget Function()? waitingWidget;

  FutureBuilderCommmon({
    super.key,
    required this.future,
    required this.child,
    this.errorWidget,
    this.waitingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return waitingWidget == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : waitingWidget!();
            default:
              if (snapshot.hasError) {
                return errorWidget == null
                    ? const Text('No Data')
                    : errorWidget as Widget;
              } else {
                if (snapshot.data == null) {
                  return errorWidget == null
                      ? const Text('No Data_')
                      : errorWidget as Widget;
                }
                final datas = snapshot.data as T;
                return child(datas);
              }
          }
        });
  }
}
