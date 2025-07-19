import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'root_plus_platform_interface.dart';

/// An implementation of [RootPlusPlatform] that uses method channels.
class MethodChannelRootPlus extends RootPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('root_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
