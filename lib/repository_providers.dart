import 'package:analytics_core/analytics_core.dart';
import 'package:auth_core/auth_core.dart';
import 'package:data_privacy/data_privacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app_dependencies.dart';
import 'package:flutter_starter_template/authentication/repository/fake_auth_repository.dart';
import 'package:purchases_core/purchases_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  // requiredValue is possible because `appDependenciesProvider` is loaded in `lib/app.dart`
  return ref.watch(
    appDependenciesProvider
        .select((deps) => deps.requireValue.sharedPreferences),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FakeAuthRepository();
}

@Riverpod(keepAlive: true)
AnalyticsRepository analyticsRepository(Ref ref) {
  return FakeAnalyticsRepository();
}

@Riverpod(keepAlive: true)
PurchasesRepository purchasesRepository(Ref ref) {
  return FakePurchasesRepository();
}

@Riverpod(keepAlive: true)
DataPrivacyRepository dataPrivacyRepository(Ref ref) {
  return DataPrivacyRepository(ref.watch(sharedPreferencesProvider));
}
