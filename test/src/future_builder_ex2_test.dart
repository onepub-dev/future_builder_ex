import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('future builder ex error', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FutureBuilder<void>(
      future: delayedError(),
      builder: (context, asyncData) {
        if (asyncData.hasError) print('Error seen');
        return const Text('hi');
      },
    ))));

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(tester.takeException(), isInstanceOf<Exception>());
  });
}

Future<void> delayedError() async {
  late final Timer timer;
  timer = Timer.periodic(const Duration(seconds: 1), (t) {
    timer.cancel();
    throw Exception('Something bad happened');
  });
}
