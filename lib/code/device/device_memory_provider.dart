import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract interface class DeviceMemoryProvider {
  Future<int?> getPhysicalRamMb();

  Future<int?> getAvailableStorageMb();

  Future<int?> getDataPartitionTotalMb();
}

class DeviceMemoryService implements DeviceMemoryProvider {
  static const MethodChannel _channel = MethodChannel('personal_ai/device_info');

  static const int minimumRamMb = 4096;
  static const int minimumStorageGb = 64;

  Future<Map<String, dynamic>?> _getDeviceSpecs() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    try {
      return await _channel.invokeMapMethod<String, dynamic>('getDeviceSpecs');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  int? _readValue(Map<String, dynamic>? specs, String key) {
    final value = specs?[key];
    return value is num ? value.toInt() : null;
  }

  @override
  Future<int?> getPhysicalRamMb() async {
    final specs = await _getDeviceSpecs();
    return _readValue(specs, 'totalRamMb');
  }

  @override
  Future<int?> getAvailableStorageMb() async {
    final specs = await _getDeviceSpecs();
    return _readValue(specs, 'availableStorageMb');
  }

  @override
  Future<int?> getDataPartitionTotalMb() async {
    final specs = await _getDeviceSpecs();
    return _readValue(specs, 'dataPartitionTotalMb');
  }
}
