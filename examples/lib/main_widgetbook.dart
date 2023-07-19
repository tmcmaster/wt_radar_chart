import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wt_radar_chart_examples/demo/demo_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: Widgetbook.material(
        addons: [
          MaterialThemeAddon(
            themes: [
              WidgetbookTheme(
                name: 'Light',
                data: ThemeData.light(),
              ),
              WidgetbookTheme(
                name: 'Dark',
                data: ThemeData.dark(),
              ),
            ],
          ),
          TextScaleAddon(
            scales: [1.0, 2.0, 4.0],
          ),
          DeviceFrameAddon(
            devices: [
              Devices.ios.iPhone12,
              Devices.ios.iPhone13Mini,
              Devices.ios.iPad,
              Devices.ios.iPhone12ProMax,
              Devices.macOS.macBookPro,
              Devices.macOS.wideMonitor,
            ],
          ),
        ],
        appBuilder: (context, child) => SafeArea(
          child: Scaffold(
            body: Center(
              child: child,
            ),
          ),
        ),
        directories: [
          WidgetbookComponent(name: 'Radar Chart', useCases: [
            WidgetbookUseCase(
              name: 'Smoke Test',
              builder: (_) => const DemoPage(),
            ),
          ]),
        ],
      ),
    ),
  );
}
