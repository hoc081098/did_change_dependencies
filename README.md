# did_change_dependencies
## Author: [Petrus Nguyễn Thái Học](https://github.com/hoc081098)

Return a `Stream` that emits null and done event when `State.didChangeDependencies` is called for the first time.

![Dart CI](https://github.com/hoc081098/did_change_dependencies/workflows/Flutter%20CI/badge.svg)
[![Pub](https://img.shields.io/pub/v/did_change_dependencies)](https://pub.dev/packages/did_change_dependencies)
[![Pub](https://img.shields.io/pub/v/did_change_dependencies?include_prereleases)](https://pub.dev/packages/did_change_dependencies)
[![codecov](https://codecov.io/gh/hoc081098/did_change_dependencies/branch/master/graph/badge.svg)](https://codecov.io/gh/hoc081098/did_change_dependencies)
[![GitHub](https://img.shields.io/github/license/hoc081098/did_change_dependencies?color=4EB1BA)](https://opensource.org/licenses/MIT)
[![Style](https://img.shields.io/badge/style-pedantic-40c4ff.svg)](https://github.com/dart-lang/pedantic)

## Example

<p align="center">
    <img src="code.png" width="700">
</p>

```dart
import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class Bloc {
  Stream<String> message$ = Stream.empty(); // just demo
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with DidChangeDependenciesStream {
  final bloc = Bloc();
  final subscriptions = <StreamSubscription<void>>[];

  @override
  void initState() {
    super.initState();

    final handle = (String msg) {
      // safe to access ScaffoldMessengerState.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    };
    subscriptions <<
        didChangeDependencies$
            .exhaustMap((value) => bloc.message$)
            .listen(handle);

    subscriptions <<
        didChangeDependencies$.listen((event) {
          // do something when `didChangeDependencies` is called for the first time.
        });
  }

  @override
  void dispose() {
    super.dispose();
    subscriptions.forEach((s) => s.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

extension _ListExt<T> on List<T> {
  void operator <<(T t) => add(t);
}
```
