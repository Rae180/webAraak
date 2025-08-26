import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/config/routes/app_router.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/locator/service_locator.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/app/my_app.dart';
import 'package:start/features/theme/bloc/theme_bloc.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  await setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => BranchesBloc(client: NetworkApiServiceHttp()),
        ),
        BlocProvider(
          create: (context) => ResourcesBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: MainApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}
// lib/core/utils/bloc_observer.dart

