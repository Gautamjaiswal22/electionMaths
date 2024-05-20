import 'package:chunavganit/drawer.dart';
import 'package:chunavganit/editTwoHour.dart';
import 'package:chunavganit/editOneHour.dart';
import 'package:chunavganit/oneHourShow.dart';
import 'package:chunavganit/twoHourshow.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

int index = 2;
void shareTextOnWhatsApp(String message) async {
  String url = "https://wa.me/?text=$message";
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Map<String, int>> hourlyRecords = {};
  List hourTitle = [
    '07:08 AM',
    '08:09 AM',
    '09:10 AM',
    '10:11 AM',
    '11:12 PM',
    '12:01 PM',
    '01:02 PM',
    '02:03 PM',
    '03:04 PM',
    '04:05 PM',
    '05:06 PM',
    '06:07 PM',
    '07:08 PM',
    '08:09 PM',
    '09:10 PM',
    '10:11 PM'
  ];

  ScrollController _scrollController = ScrollController();

  Map<String, dynamic> lastBoothRecord = {};

  @override
  Widget build(BuildContext context) {
    double mqw = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('चुनाव गणित'),
          actions: [
            SizedBox(
              width: mqw * 0.02,
            ),
            CircleAvatar(
              backgroundColor: index == 1 ? Colors.black : Colors.white,
              child: IconButton(
                  onPressed: () {
                    index = 1;
                    setState(() {});
                  },
                  icon: Text(
                    "1",
                    style: TextStyle(
                        color: index == 1 ? Colors.white : Colors.black),
                  )),
            ),
            CircleAvatar(
              backgroundColor: index == 2 ? Colors.black : Colors.white,
              child: IconButton(
                  // color: Colors.amber,
                  isSelected: index == 2,
                  onPressed: () {
                    index = 2;
                    setState(() {});
                  },
                  icon: Text(
                    "2",
                    style: TextStyle(
                        color: index == 2 ? Colors.white : Colors.black),
                  )),
            )
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   backgroundColor: Colors.green,
            //   foregroundColor: Colors.white,
            //   onPressed: () {
            //     shareTextOnWhatsApp("HELLO");
            //     // Navigator.of(context).push(
            //     // MaterialPageRoute(builder: (context) => HourlyRecordPage()));
            //   },
            //   child: const Icon(Icons.share),
            // ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onPressed: () {
                if (index == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditHourlyRecord()));
                } else if (index == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditTwoHourRecord()));
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: index == 1 ? HourlyRecord() : TwoHourRecord());
  }

  void updateHourlyRecord(String hour, String gender, int count) {
    if (!hourlyRecords.containsKey(hour)) {
      hourlyRecords[hour] = {};
    }
    hourlyRecords[hour]![gender] = count;
    print(hourlyRecords);
    // setState(() {
    //   if (!hourlyRecords.containsKey(hour)) {
    //     hourlyRecords[hour] = {};
    //   }
    //   hourlyRecords[hour]![gender] = count;
    //   print(hourlyRecords);
    // });
  }

  Widget _voteData(var maleController, var femaleController, String hour,
      int index, int totalMale, int totalFemale) {
    double mqw = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;
    String malepercentage =
        ((maleController / totalMale) * 100).toStringAsFixed(2);
    String femalePercentage =
        ((femaleController / totalMale) * 100).toStringAsFixed(2);
    return Container(
      color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: mqw * 0.2,
                  child: Text(hour,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Container(
                  // decoration: BoxDecoration(border: Border(left: BorderSide(), right: BorderSide())),
                  width: mqw * 0.2,
                  child: Text(
                    maleController.toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  // decoration: BoxDecoration(border: Border(left: BorderSide(), right: BorderSide())),
                  width: mqw * 0.2,
                  child: Text(
                    "${malepercentage} %",
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                // Expanded(
                //   child: TextFormField(
                //     // controller: maleController,
                //     keyboardType: TextInputType.number,
                //     onChanged: (value) {
                //       updateHourlyRecord(hour, 'male', int.tryParse(value) ?? 0);
                //     },
                //   ),
                // ),
                const SizedBox(width: 16),
                Container(
                    width: mqw * 0.2,
                    child: Text(
                      femaleController.toString(),
                      style: const TextStyle(color: Colors.pink),
                    )),
                const SizedBox(width: 10),

                Container(
                  // decoration: BoxDecoration(border: Border(left: BorderSide(), right: BorderSide())),
                  width: mqw * 0.2,
                  child: Text(
                    "${femalePercentage} %",
                    style: const TextStyle(
                        color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ),
                // Expanded(
                //   child: TextFormField(
                //     keyboardType: TextInputType.number,
                //     // controller: femaleController,
                //     onChanged: (value) {
                //       updateHourlyRecord(
                //           hour, 'female', int.tryParse(value) ?? 0);
                //     },
                //   ),
                // ),

                const SizedBox(width: 16),
                Container(
                    width: mqw * 0.2,
                    child: const Text(
                      "0",
                      style: TextStyle(color: Colors.red),
                    )),
                // Expanded(
                //   child: TextFormField(
                //     keyboardType: TextInputType.number,
                //     onChanged: (value) {
                //       updateHourlyRecord(hour, 'other', int.tryParse(value) ?? 0);
                //     },
                //   ),
                // ),
                Container(
                    width: mqw * 0.2,
                    child: const Text(
                      "0",
                      style: TextStyle(color: Colors.red),
                    )),
                IconButton(
                    onPressed: () {
                      String message = '''
समय : $hour,
पुरुष : $maleController,
पुरुष % :$malepercentage %,
महिला : $femaleController,
महिला % : $femalePercentage %,
अन्य : 0
''';
                      shareTextOnWhatsApp(message);
                    },
                    icon: Icon(Icons.share))
              ],
            ),
            // const Divider()
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.of(context).push(
  //             MaterialPageRoute(builder: (context) => HourlyRecordPage()));
  //       },
  //       child: Icon(Icons.add),
  //     ),
  //     body: Column(),
  //   );
  // }
}

class BoothInfoBox extends StatelessWidget {
  final String boothKramank;
  final String adhikariName;
  final String pata;

  const BoothInfoBox({
    required this.boothKramank,
    required this.adhikariName,
    required this.pata,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'बूथ क्रमांक: $boothKramank',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'अधिकारी का नाम: $adhikariName',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'पता: $pata',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
