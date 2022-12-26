import 'dart:collection';
import 'dart:math';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curae/components/emoji_button.dart';
import 'package:curae/components/size_components.dart';
import 'package:curae/services/quote_api.dart';
import 'package:curae/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _statsDb = FirebaseFirestore.instance.collection('stats');
  String wishUser(int hour) {
    if (hour >= 4 && hour <= 11) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour <= 16) {
      return 'Good Afternoon!';
    } else if (hour >= 17 && hour <= 19) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

  int tag = 0;
  List<String> options = ['Today', 'Last 7 days', 'This month'];

  Future updateStats(String emotion) async {
    await _statsDb.add({
      'uid': _auth.currentUser!.uid,
      'emotion': emotion,
      'date': DateTime.now(),
    });
  }

  final queryCategories = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  ];

  List<Color> pieChartColors = [
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.greenAccent.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100
  ];

  Map<String, dynamic> stats = {
    'happy': 0,
    'sad': 0,
    'excited': 0,
    'pleasant': 0,
    'angry': 0,
    'depressed': 0,
  };
  Future getStats(DateTime fromDate) async {
    var data = await FirebaseFirestore.instance
        .collection('stats')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isLessThan: DateTime.now(), isGreaterThan: fromDate)
        .get();
    data.docs.forEach((snapshot) {
      var snapData = snapshot.data();
      stats[snapData['emotion']] = stats[snapData['emotion']] + 1;
    });
    filterStats();
  }

  Future filterStats() async {
    setState(() {
      data = [];
    });
    int i = 0;
    stats.forEach((key, value) {
      data.add(
        PieChartSectionData(
          title: key,
          value: value.toDouble(),
          color: pieChartColors[i++],
          radius: 75,
          showTitle: false,
        ),
      );
    });
    print(stats);
    setState(() {
      data = data;
      stats = {
        'happy': 0,
        'sad': 0,
        'excited': 0,
        'pleasant': 0,
        'angry': 0,
        'depressed': 0,
      };
    });
  }

  String getMaxEmotion() {
    Set<int> vals = new HashSet();

    stats.forEach((key, value) {
      vals.add(value);
    });
    var isUnique = vals.length == 1;
    if (isUnique) {
      return 'Neutral';
    }
    var emos = stats.entries.toList();
    var max = emos.first;
    emos.forEach((element) {
      if (element.value > max.value) {
        max = element;
      }
    });
    return max.key;
  }

  List<PieChartSectionData> data = [];

  @override
  void initState() {
    super.initState();
    getStats(queryCategories[tag]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeight(24),
              //APPBAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wishUser(DateTime.now().hour),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.data();
                            return Text(
                              data!['first name'] + " " + data['last name'],
                              style: TextStyle(fontSize: 18),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('');
                          } else {
                            return Text('Error while loading!');
                          }
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      var quoteBody = await getQuote();
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: Container(
                            padding: EdgeInsets.all(24),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(quoteBody.quote),
                                buildHeight(8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('~ ' + quoteBody.author),
                                ),
                                buildHeight(8),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryTextColor,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Just Smile 😊')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: primaryTextColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              buildHeight(24),
              //ASK_DAY_STATUS
              Container(
                padding: EdgeInsets.all(32),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'How are you feeling right now?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    buildHeight(22),
                    Wrap(
                      runSpacing: 24,
                      spacing: 38,
                      children: [
                        EmoButton(
                            emoji: '😇',
                            onTap: () async {
                              await updateStats('pleasant');
                            }),
                        EmoButton(
                            emoji: '😂',
                            onTap: () async {
                              await updateStats('happy');
                            }),
                        EmoButton(
                            emoji: '🤩',
                            onTap: () async {
                              await updateStats('excited');
                            }),
                        EmoButton(
                            emoji: '😐',
                            onTap: () async {
                              await updateStats('depressed');
                            }),
                        EmoButton(
                            emoji: '😭',
                            onTap: () async {
                              await updateStats('sad');
                            }),
                        EmoButton(
                            emoji: '😡',
                            onTap: () async {
                              await updateStats('angry');
                            }),
                      ],
                    ),
                    buildHeight(8),
                  ],
                ),
              ),
              buildHeight(24),
              //STATS_SELECTION_CATEGORY
              Text(
                'Your stats',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              buildHeight(6),
              SizedBox(
                width: double.infinity,
                child: ChipsChoice<int>.single(
                  choiceStyle: C2ChipStyle.filled(
                    selectedStyle: C2ChipStyle(
                      foregroundStyle: TextStyle(color: Colors.white),
                      backgroundColor: secondaryColor,
                    ),
                  ),
                  wrapped: true,
                  alignment: WrapAlignment.spaceBetween,
                  value: tag,
                  onChanged: (val) {
                    setState(() => tag = val);
                    getStats(queryCategories[tag]);
                  },
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                ),
              ),
              buildHeight(12),
              //STATS_CHART
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: PieChart(
                        PieChartData(
                            sections: data,
                            centerSpaceRadius: 0,
                            startDegreeOffset: 270),
                      ),
                    ),
                    buildHeight(18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        PieChip(
                            pieChartColor: pieChartColors[0], title: 'Happy'),
                        PieChip(pieChartColor: pieChartColors[1], title: 'Sad'),
                        PieChip(
                            pieChartColor: pieChartColors[2], title: 'Excited'),
                        PieChip(
                            pieChartColor: pieChartColors[3],
                            title: 'Pleasant'),
                        PieChip(
                            pieChartColor: pieChartColors[4], title: 'Angry'),
                        PieChip(
                            pieChartColor: pieChartColors[5],
                            title: 'Depressed'),
                      ],
                    ),
                  ],
                ),
              ),
              buildHeight(16),
              //DAY_WISH
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Center(
                    child: Text('Your\'e mood was more ' +
                        getMaxEmotion() +
                        " today!")),
              ),
              buildHeight(36),
            ],
          ),
        ),
      ),
    );
  }
}

class PieChip extends StatelessWidget {
  const PieChip({
    Key? key,
    required this.pieChartColor,
    required this.title,
  }) : super(key: key);

  final Color pieChartColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: pieChartColor, borderRadius: BorderRadius.circular(8)),
          ),
          buildWidth(12),
          Text(title),
        ],
      ),
    );
  }
}
