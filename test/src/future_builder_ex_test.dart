import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:future_builder_ex/src/empty.dart';

void main() {
  testWidgets('future builder ex check builders', (tester) async {
    final completer = Completer<void>();
    late final Timer timer;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timer.cancel();
      completer.complete();
    });

    var buildCalled = Completer<bool>();
    await testBuild(tester, () => completer.future, buildCalled);

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(buildCalled.isCompleted, isTrue);

    ///
    buildCalled = Completer<bool>();
    await testBuild(tester, instantFuture, buildCalled);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(buildCalled.isCompleted, isTrue);
  });

  /// WAITING
  testWidgets('no initialData', (tester) async {
    final buildCalled = Completer<bool>();
    final waitingCalled = Completer<bool>();

    /// with no initial data the waitBuilder should be called
    /// at least once.
    await testWidget<bool>(
      tester: tester,
      future: () => waitSeconds(2),
      waitingCallback: () => waitingCalled.complete(true),
      buildCallback: buildCalled.complete,
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(waitingCalled.isCompleted, isTrue);
    expect(buildCalled.isCompleted, isTrue);
  });

  testWidgets('have initialData - waiting should be skipped', (tester) async {
    final waitingCalled = Completer<bool>();

    /// with initial data the waitBuilder should not be called
    /// at least once.
    await testWidget<bool>(
      tester: tester,
      initialData: true,
      future: () => waitSeconds(2),
      waitingCallback: () => waitingCalled.complete(true),
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(waitingCalled.isCompleted, isFalse);
  });

  testWidgets('future starts completed ', (tester) async {
    var waitingCalled = 0;
    final buildCalled = Completer<bool>();

    /// If the future is completed on start up waiting shouldn't be called.
    await testWidget<bool>(
      tester: tester,
      future: () => Future.value(true),
      waitingCallback: () => waitingCalled++,
      buildCallback: buildCalled.complete,
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));
    // wait should only be called once
    expect(waitingCalled == 1, isTrue);
    // builder should be called.
    expect(buildCalled.isCompleted, isTrue);
  });

  testWidgets('future builder ex error', (tester) async {
    final buildCalled = Completer<bool>();
    await testBuild(tester, errorFuture, buildCalled);
    expect(tester.takeException(), isInstanceOf<Exception>());
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(buildCalled.isCompleted, isTrue);
  });

  testWidgets('future builder ex delayed error', (tester) async {
    ///
    final buildCalled = Completer<bool>();
    final errorCalled = Completer<bool>();
    await testWidget(
      tester: tester,
      future: networkFuture,
      buildCallback: (data) {},
      errorCallback: (error) {
        errorCalled.complete(true);
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(buildCalled.isCompleted, isFalse);
    expect(errorCalled.isCompleted, isTrue);
  });
}

Future<void> testBuild<T>(WidgetTester tester, Future<T> Function() callback,
    Completer<bool> buildCalled) async {
  await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          body: FutureBuilderEx<void>(
    future: () => callback(),
    builder: (context, _) => build(context, buildCalled),
  ))));
}

Future<void> testWidget<T>({
  required WidgetTester tester,
  required Future<T> Function() future,
  T? initialData,
  void Function(T? data)? buildCallback,
  void Function()? waitingCallback,
  void Function(Object?)? errorCallback,
}) async {
  await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          body: FutureBuilderEx<T>(
              future: future,
              initialData: initialData,
              waitingBuilder: (context) {
                waitingCallback?.call();
                return const Empty();
              },
              builder: (context, data) {
                buildCallback?.call(data);
                return const Empty();
              },
              errorBuilder: (context, error) {
                errorCallback?.call(error);
                return const Empty();
              }))));
}

Widget build(BuildContext context, Completer<bool> buildCalled) {
  if (!buildCalled.isCompleted) {
    buildCalled.complete(true);
  }
  return const Text('hoi');
}

// Future<void> delayedError() async {
//   late final Timer timer;
//   print('delayed error started');
//   timer = Timer.periodic(const Duration(seconds: 1), (t) {
//     print('in timer');
//     timer.cancel();
//     throw Exception('Something bad happened');
//   });
// }

Future<bool> networkFuture() => Future.delayed(const Duration(seconds: 1), () {
      throw Exception('Something bad happened');
    });

Future<void> instantFuture() => Future.value();

Future<void> errorFuture() async {
  throw Exception('Something bad happened');
}

/// returns a future which waits [seconds] and the completes
Future<bool> waitSeconds(int seconds) async {
  final waiting = Completer<bool>();
  late final Timer timer;
  print('delayed error started');
  timer = Timer.periodic(Duration(seconds: seconds), (t) {
    timer.cancel();
    waiting.complete(true);
  });

  return waiting.future;
}
