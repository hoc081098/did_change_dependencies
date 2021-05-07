import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with DidChangeDependenciesStream {
  late final StreamSubscription<int> subscription1;
  late final StreamSubscription<void> subscription2;

  final values = <int>[];
  var hasValue = false;
  var done = false;

  @override
  void initState() {
    super.initState();

    subscription1 = didChangeDependencies$
        .exhaustMap(
            (_) => Stream.periodic(const Duration(seconds: 10), (i) => i))
        .listen((i) {
      values.add(i);
      print('[1] $i');
    });

    subscription2 = didChangeDependencies$.listen(
      (i) => hasValue = true,
      onDone: () => done = true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription1.cancel();
    subscription2.cancel();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  testWidgets('did_change_dependencies', (tester) async {
    final key = GlobalKey<_TestWidgetState>();

    await tester.pumpWidget(TestWidget(key: key));
    await tester.pump(const Duration(seconds: 25)); // emits

    final vs = key.currentState!.values;
    expect(vs.length, 2);
    expect(vs, [0, 1]);

    expect(key.currentState!.hasValue, true);
    expect(key.currentState!.done, true);

    await tester.pumpWidget(const SizedBox());
  });
}
