import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the current time. Injected so tests can pin "today".
typedef Clock = DateTime Function();

final clockProvider = Provider<Clock>((ref) => DateTime.now);
