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
