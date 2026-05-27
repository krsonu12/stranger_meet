import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wire up all dependencies
  await configureDependencies();

  runApp(const StrangerMeetApp());
}

class StrangerMeetApp extends StatefulWidget {
  const StrangerMeetApp({super.key});

  @override
  State<StrangerMeetApp> createState() => _StrangerMeetAppState();
}

class _StrangerMeetAppState extends State<StrangerMeetApp> {
  // AuthBloc lives at app root — single instance drives GoRouter redirects.
  late final AuthBloc _authBloc;
  late final ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _themeCubit = sl<ThemeCubit>();
  }

  @override
  void dispose() {
    _authBloc.close();
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final router = AppRouter.createRouter(_authBloc);
          return MaterialApp.router(
            title: 'StrangerMeet',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
