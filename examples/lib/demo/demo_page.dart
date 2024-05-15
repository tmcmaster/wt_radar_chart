import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wt_logging/wt_logging.dart';
import 'package:wt_radar_chart/wt_radar_chart.dart';

class DemoPage extends StatefulWidget {
  static final Random random = Random();

  static const features = [
    'Happiness',
    'Fulfilment',
    'Supported',
    'Concern',
  ];

  static final Map<String, List<List<int>>> dataSetMap = {
    for (int group = 0; group < 8; group++)
      'Group ${group + 1}': Iterable.generate(random.nextInt(3) + 2)
          .map((e) => Iterable.generate(features.length).map((_) => random.nextInt(5) + 1).toList())
          .toList(),
  };

  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  static final log = logger(DemoPage);

  String group = DemoPage.dataSetMap.keys.first;

  @override
  Widget build(BuildContext context) {
    log.d(DemoPage.dataSetMap);
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Wrap(
              children: DemoPage.dataSetMap.keys
                  .map(
                    (g) => TextButton(
                      onPressed: () {
                        setState(() {
                          group = g;
                        });
                      },
                      child: Text(g),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: RadarChart(
              //sides: DemoPage.dataSetMap.length,
              reverseAxis: false,
              outlineColor: Colors.grey.shade400,
              axisColor: Colors.grey.shade400,
              ticksTextStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
              featuresTextStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              ticks: const [1, 2, 3, 4, 5],
              features: DemoPage.features,
              data: DemoPage.dataSetMap[group]!,
              labelSpacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}
