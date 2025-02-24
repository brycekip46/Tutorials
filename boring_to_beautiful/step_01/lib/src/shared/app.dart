// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'playback/bloc/bloc.dart';
import 'providers/theme.dart';
import 'router.dart';
import 'views/views.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settings = ValueNotifier(ThemeSettings(
    sourceColor: Color.fromARGB(255, 8, 44, 49), // Replace this color
    themeMode: ThemeMode.system,
  ));
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaybackBloc>(
      create: (context) => PlaybackBloc(),
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => ThemeProvider(
            lightDynamic: lightDynamic,
            darkDynamic: darkDynamic,
            settings: settings,
            child: NotificationListener<ThemeSettingChange>(
              onNotification: (notification) {
                settings.value = notification.settings;
                return true;
              },
              child: ValueListenableBuilder<ThemeSettings>(
                valueListenable: settings,
                builder: (context, value, _) {
                  final theme = ThemeProvider.of(context);

                  // Create theme instance
                  return MaterialApp.router(
                    scrollBehavior: const ConstantScrollBehavior(),
                    debugShowCheckedModeBanner: false,
                    title: 'MusixPlayer',
                    theme: theme.light(settings.value.sourceColor),
                    darkTheme: theme.dark(settings.value.sourceColor),
                    themeMode: theme.themeMode(),
                    routeInformationParser: appRouter.routeInformationParser,
                    routeInformationProvider:
                        appRouter.routeInformationProvider,
                    routerDelegate: appRouter.routerDelegate,
                    builder: (context, child) {
                      return PlayPauseListener(child: child!);
                    },
                  );
                },
              ),
            )),
      ),
    );
  }
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails detail) =>
      child;

  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.linux;

  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
