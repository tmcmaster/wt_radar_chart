import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wt_app_scaffold/app_scaffolds.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_logging/wt_logging.dart';
import 'package:wt_radar_chart_examples/demo/demo_page.dart';
import 'package:wt_radar_chart_examples/secrets/firebase_options.dart';

void main() {
  runMyApp(
    withFirebase(
      andAppScaffold(
        appDetails: RadarChartApp.details,
        appDefinition: RadarChartApp.definition,
        loginSupport: const LoginSupport(
          googleEnabled: true,
          emailEnabled: true,
        ),
        setApplicationLogLevel: Level.warning,
      ),
      appName: 'wt-app-scaffold',
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    ),
    enableProviderMonitoring: true,
  );
}

mixin RadarChartApp {
  static final details = Provider(
    name: 'Radar Chart App Details',
    (ref) => AppDetails(
      title: 'Radar Chart',
      subTitle: 'Prototype',
      iconPath: 'assets/avocado.png',
    ),
  );

  static final definition = Provider<AppDefinition>(
    name: 'Radar Chart App Definition',
    (ref) {
      return AppDefinition.from(
        appTitle: 'Radar Chart Demo',
        appName: 'wtRadarChart',
        appDetailsProvider: details,
        includeAppBar: true,
        menuAction: (context) => HiddenDrawerOpener.of(context)?.open(),
        pages: [
          PageDefinition(
            title: 'Radar Chart Demo',
            icon: FontAwesomeIcons.section,
            builder: (context) => const DemoPage(),
            primary: true,
          ),
        ],
        localizationDelegates: [],
      );
    },
  );
}
