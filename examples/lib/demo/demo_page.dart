import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wt_radar_chart/wt_radar_chart.dart';

class DemoPage extends StatefulWidget {
  static final Random random = Random();

  static List<List> list = Iterable.generate(5).map((e) => []).toList();

  static final Map<String, List<List<int>>> dataSetMap = {
    for (int group = 0; group < 8; group++)
      'Group ${group + 1}': Iterable.generate(random.nextInt(5) + 1)
          .map((e) => Iterable.generate(5).map((_) => random.nextInt(4) + 0).toList())
          .toList()
  };

  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String group = DemoPage.dataSetMap.keys.first;

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            width: 400,
            height: 200,
            child: RadarChart(
              // sides: 4,
              reverseAxis: false,
              outlineColor: Colors.grey.shade400,
              featuresTextStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              ticks: const [1, 2, 3, 4, 5],
              features: const ['Happiness', 'Fulfilment', 'Supported', 'Concern'],
              data: DemoPage.dataSetMap[group]!,
            ),
          )
        ],
      ),
    );
  }
}
