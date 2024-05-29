import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'empty.dart';
import 'tick_builder.dart';

typedef CompletedBuilder<T> = Widget Function(BuildContext context, T? data);
typedef WaitingBuilder<T> = Widget Function(BuildContext context);
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);

typedef SubscribeTo<S> = void Function(S type);

///
/// ```dart
///  return Consumer<SelectedTeam>(
///      builder: (context, selectedTeam, _) => FutureBuilderEx<String>(
///        future: selectedTeam.teamName,
///        builder: (context, teamName) => NJTextSubheading('Team: $teamName'
///           , color: Colors.white),
///      ),
///    );
/// ```
class FutureBuilderEx<T> extends StatefulWidget {
  /// [T] is the type returned by the function passed to the [future]
  /// parameter. If your [future] returns a void then you must declare
  /// ```FutureBuilderEx<void>(...)```
  /// We guarentee that we will only call the [future] function once
  /// during the lifecycle of this instance.
  ///
  /// The [waitingBuilder] is called when the UI needs to be
  /// rendered but the [future] hasn't completed and there
  /// is no [initialData].
  ///
  /// When the [builder] is called it will be passed
  /// the [BuildContext] and the current data which will be either
  /// the [initialData] or the data returned from the [future]
  ///
  /// If [initialData] is passed a non-null value then
  /// the [waitingBuilder] will never be called and instead the
  /// [builder] will be called esentially immediately.
  /// When the future completes the [builder] method will be
  /// called again with the new value.
  ///
  /// The [errorBuilder] is called when the [future] returns
  /// an error and is passed the [BuildContext] and the
  /// error object thrown by the [future].
  ///
  const FutureBuilderEx({
    required this.future,
    required this.builder,
    super.key,
    this.initialData,
    this.waitingBuilder,
    this.errorBuilder,
    this.debugLabel = '',
  });
  //Future args
  final WaitingBuilder<T>? waitingBuilder;
  final ErrorBuilder? errorBuilder;
  final CompletedBuilder<T> builder;

  final Future<T> future;
  final T? initialData;
  final String debugLabel;

  @override
  State<StatefulWidget> createState() => FutureBuilderExState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('debugLabel', debugLabel))
      ..add(DiagnosticsProperty<Future<T>>('future', future))
      ..add(ObjectFlagProperty<CompletedBuilder<T>>.has('builder', builder))
      ..add(ObjectFlagProperty<ErrorBuilder?>.has('errorBuilder', errorBuilder))
      ..add(ObjectFlagProperty<WaitingBuilder<T>?>.has(
          'waitingBuilder', waitingBuilder))
      ..add(DiagnosticsProperty<T?>('initialData', initialData));
  }
}

class FutureBuilderExState<T> extends State<FutureBuilderEx<T>> {
  // set to true once the future has completed.
  bool completed = false;

  // late Future<T> stateFuture;

  @override
  void initState() {
    super.initState();
  }

  // void _initialiseFuture() {
  //   stateFuture = widget.future;
  //   stateFuture.whenComplete(() => setState(() => completed = true));
  // }

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
      future: widget.future,
      initialData: widget.initialData,
      builder: _handleBuilder);

  Widget _handleBuilder(BuildContext context, AsyncSnapshot<T> data) {
    try {
      return _loadBuilder(context, data);
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      Logger().d(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  Widget _loadBuilder(BuildContext context, AsyncSnapshot<T> snapshot) {
    Widget builder;

    if (snapshot.hasError) {
      builder = _callErrorBuilder(context, snapshot.error!);
    } else {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          if (widget.initialData == null) {
            builder = _callWaitingBuilder(context);
          } else {
            builder = widget.builder(context, widget.initialData);
          }
          break;
        case ConnectionState.waiting:
          final data = completed ? snapshot.data : widget.initialData;
          if (!completed && data == null) {
            builder = _callWaitingBuilder(context);
          } else {
            builder = widget.builder(context, data);
          }
          break;
        case ConnectionState.active:
          builder = widget.builder(context, snapshot.data);
          break;
        case ConnectionState.done:
          builder = widget.builder(context, snapshot.data);
          break;
      }
    }
    return builder;
  }

  Widget _callWaitingBuilder(BuildContext contect) {
    if (widget.waitingBuilder != null) {
      return widget.waitingBuilder!(context);
    } else {
      return _loading();
    }
  }

  Widget _callErrorBuilder(BuildContext context, Object error) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context, error);
    } else {
      return Center(child: Text('An error occured: $error.'));
    }
  }

  /// Displays a loading message.
  /// For the first 500ms we just show an empty container as
  /// this reduces flicker when the component loads quickly.
  Widget _loading() {
    final startTime = DateTime.now();
    return TickBuilder(
        interval: const Duration(milliseconds: 100),
        builder: (context, index) {
          final showLoading = DateTime.now().difference(startTime) >
              const Duration(milliseconds: 500);
          if (showLoading) {
            return const Center(child: Text('Loading...'));
          } else {
            return const Empty();
          }
        });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('completed', completed));
  }
}
