import 'package:english_app/presentation/ui/bottom/bottom_navigation.dart';
import 'package:english_app/presentation/ui/page/note/note_page.dart';
import 'package:english_app/presentation/ui/page/review/review_page.dart';
import 'package:english_app/presentation/ui/page/vocabulary/vocabulary_page.dart';
import 'package:english_app/presentation/ui/splash/splash.dart';
import 'package:english_app/presentation/view_models/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TheApp extends ConsumerStatefulWidget {
  const TheApp({super.key});

  @override
  ConsumerState<TheApp> createState() => _TheAppState();
}

class _TheAppState extends ConsumerState<TheApp> {
  late final Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initialize();
  }

  Future<void> _initialize() async {
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      home: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SplashPage();
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: IndexedStack(
                index: ref.watch(appViewModel).indexTab,
                children: [
                  VocabularyPage(),
                  ReviewPage(),
                  NotePage(),
                ],
              ),
              bottomNavigationBar: const BottomNavigation(),
            ),
          );
        },
      ),
    );
  }
}