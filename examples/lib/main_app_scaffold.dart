import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wt_app_scaffold/app_platform/scaffold_app_dsl.dart';
import 'package:wt_app_scaffold/app_scaffolds.dart';
import 'package:wt_logging/wt_logging.dart';
import 'package:wt_radar_chart_examples/demo/demo_page.dart';

void main() {
  runMyApp(
    // withFirebase(
    //   andAuthentication(
    //     andFirebaseLogin(
    andAppScaffold(
      appStyles: SharedAppConfig.styles,
      appDetails: RadarChartApp.details,
      appDefinition: RadarChartApp.definition,
    ),
    //     googleEnabled: true,
    //     emailEnabled: true,
    //   ),
    // ),
    //   appName: 'wt-app-scaffold',
    //   firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    // ),
    enableProviderMonitoring: true,
    setApplicationLogLevel: Level.warning,
  );
}

mixin RadarChartApp {
  static final details = AppDetails(
    title: 'Radar Chart',
    subTitle: 'Prototype',
    iconPath: 'assets/avocado.png',
  );

  static final appDetailsProvider = Provider((ref) => details);

  static final definition = AppDefinition.from(
    appTitle: 'Radar Chart Demo',
    appName: 'wtRadarChart',
    appDetailsProvider: appDetailsProvider,
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
}
