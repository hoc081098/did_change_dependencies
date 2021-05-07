import 'dart:async';

import 'package:flutter/widgets.dart';

/// A mixin that provides the [Stream] that emits `null` and done event
/// when [State.didChangeDependencies] is called for the first time.
@optionalTypeArgs
mixin DidChangeDependenciesStream<T extends StatefulWidget> on State<T> {
  var _emitted = false;
  final _controller = StreamController<void>(sync: true);

  Stream<void> get didChangeDependencies$ => _controller.stream;

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_emitted) {
      return;
    }

    _emitted = true;
    _controller.add(null);
    scheduleMicrotask(_controller.close);
  }
}
