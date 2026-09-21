// test/test_utils.dart

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

/// Makes the test screen very tall. Lists only build the items near the
/// visible area, so on a tall screen every item exists and tests do not have
/// to scroll (or depend on how tall the text happens to be).
void useTallScreen(WidgetTester tester, {double height = 4000}) {
  tester.view.physicalSize = Size(800, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}
