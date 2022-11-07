import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

void main() {
  testWidgets('future builder ex ...', (tester) async {
    var timer = Completer<void>();
    Timer.periodic(Duration(seconds: 1), (t) {
      timer.complete();
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(FutureBuilderEx<void>(
      future: timer.future,
      builder: (context, _) => build(context),
      stackTrace: StackTraceImpl(),
    ));
  });
}

Widget build(BuildContext context) {
  return Text('hoi');
}
