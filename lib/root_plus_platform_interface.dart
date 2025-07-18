import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'root_plus_method_channel.dart';

abstract class RootPlusPlatform extends PlatformInterface {
  /// Constructs a RootPlusPlatform.
  RootPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static RootPlusPlatform _instance = MethodChannelRootPlus();

  /// The default instance of [RootPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelRootPlus].
  static RootPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RootPlusPlatform] when
  /// they register themselves.
  static set instance(RootPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
