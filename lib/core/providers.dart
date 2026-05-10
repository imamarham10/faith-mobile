import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'network/dio_client.dart';
import 'storage/secure_storage.dart';

part 'providers.g.dart';

/// Shared providers used across the app.
///
/// Keep this file lean — feature-specific providers should live with their
/// feature, not here.

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => SecureStorage();

@Riverpod(keepAlive: true)
Dio dio(Ref ref) => DioClient.create(ref.watch(secureStorageProvider));
