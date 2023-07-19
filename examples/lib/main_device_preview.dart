import 'package:device_preview/device_preview.dart';
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
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: DevicePreview(
                builder: (context) => const SafeArea(
                  child: DemoPage(),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
