import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:feline_dash/app.dart';

void main() {
  testWidgets('App smoke test — FelineDashApp mounts', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FelineDashApp()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
