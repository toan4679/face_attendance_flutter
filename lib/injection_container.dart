import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await ApiClient.initialize();
  sl.registerLazySingleton(() => ApiClient.dio);
}
