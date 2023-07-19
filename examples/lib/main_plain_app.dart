import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_radar_chart_examples/demo/demo_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Radar Chart Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: SafeArea(
            child: Center(
              child: DemoPage(),
            ),
          ),
        ),
      ),
    ),
  );
}
