import 'package:chunavganit/constant.dart';
import 'package:chunavganit/editTwoHour.dart';
import 'package:chunavganit/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditHourlyRecord extends StatefulWidget {
  @override
  _EditHourlyRecordState createState() => _EditHourlyRecordState();
}

class _EditHourlyRecordState extends State<EditHourlyRecord> {
  TextEditingController _totalMaleController = TextEditingController();
  TextEditingController _totalFemaleController = TextEditingController();
  TextEditingController _totalOtherController = TextEditingController();
  TextEditingController _totalVoteController = TextEditingController();
  // Define variables to store data
  Map<String, Map<String, int>> hourlyRecords = {};
  Map<String, int> totalRecord = {};
  Map<String, dynamic>? lastBoothRecord;
  bool isLoading = false;
  List hourTitle = [
    '07 से 08 AM',
    '08 से 09 AM',
    '09 से 10 AM',
    '10 से 11 AM',
    '11 से 12 PM',
    '12 से 01 PM',
    '01 से 02 PM',
    '02 से 03 PM',
    '03 से 04 PM',
    '04 से 05 PM',
    '05 से 06 PM',
    '06 से 07 PM',
    '07 से 08 PM',
    '08 से 09 PM',
    '09 से 10 PM',
    '10 से 11 PM'
  ];
  List<int> maleCount = List<int>.generate(24, (index) => 0);
  List<int> femaleCount = List<int>.generate(24, (index) => 0);
  List<int> otherCount = List<int>.generate(24, (index) => 0);
  int total = 0;
  int male = 0;
  int female = 0;
  int other = 0;
  //FROM FIREBASE
  String totalCount = '';
  String totalMale = "0";
  String totalFemale = "0";
  String totalOther = "0";
  int totalCalculated = 0;

  // bool isIncreasingWithZerosOnRight2(List<int> list) {
  //   // Find the index of the first zero element
  //   int firstZeroIndex = list.indexOf(0);
  //   if (firstZeroIndex == -1) {
  //     // If there are no zeros, consider the whole list
  //     firstZeroIndex = list.length;
  //   }

  //   // Divide the list into two parts
  //   List<int> leftList = list.sublist(0, firstZeroIndex);
  //   List<int> rightList = list.sublist(firstZeroIndex);

  //   // Check if the left list is in increasing order
  //   bool increasingLeft = true;
  //   for (int i = 0; i < leftList.length - 1; i++) {
  //     if (leftList[i] > leftList[i + 1]) {
  //       increasingLeft = false;
  //       break;
  //     }
  //   }

  //   // Check if the right list contains all zeros
  //   bool allZerosRight = rightList.every((element) => element == 0);

  //   // Return true only if the left list is increasing and the right list contains all zeros
  //   return increasingLeft && allZerosRight;
  // }

  void updateHourlyRecord(String hour, String gender, int count) {
    setState(() {
      if (!hourlyRecords.containsKey(hour)) {
        hourlyRecords[hour] = {};
      }
      hourlyRecords[hour]![gender] = count;
      int ind = hourTitle.indexOf(hour);

      if (gender == "male") {
        maleCount[ind] = count;
      } else if (gender == "female") {
        femaleCount[ind] = count;
      } else {
        otherCount[ind] = count;
      }
    });
    print(hourlyRecords);
  }

  save() {
    Map oneValue = {'female': 30, 'male': 10, 'other': '10'};
    // Map<Object, Object> updateValue = {'hourlyRecord.5': oneValue};
    Map<Object, Object> updateValue = {};

    if (isIncreasingWithZerosOnRight2(maleCount) &&
        isIncreasingWithZerosOnRight2(femaleCount) &&
        isIncreasingWithZerosOnRight2(otherCount)) {
      for (var temp in hourlyRecords.keys) {
        int ind = hourTitle.indexOf(temp);
        // updateValue['hourlyRecord.$ind'] =
        //     hourlyRecords[temp] as Map<Object, Object>;
        for (var temp2 in hourlyRecords[temp]!.keys) {
          updateValue['hourlyRecord.$ind.$temp2'] =
              hourlyRecords[temp]![temp2] as int;
        }
        // updateValue['hourlyRecord.$ind'] =
        //     hourlyRecords[temp] as Map<Object, Object>;
      }
      for (var temp in totalRecord.keys) {
        // int ind = hourTitle.indexOf(temp);
        updateValue['totalRecord.$temp'] = totalRecord['$temp'] as int;
      }

      try {
        FirebaseFirestore.instance
            .collection("Voting")
            .doc('votingRecords')
            .collection("hourlyRecord")
            .doc('${logindocId}')
            .update(updateValue);
        print("Succefully updated");
        hourlyRecords.clear();
        setState(() {});
        Navigator.of(context).pop();
      } catch (e) {
        print("Error $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Count is not in Increasing order");
      print("Count is not in Increasing order");
      print("male count ${isIncreasingWithZerosOnRight2(maleCount)}");
      print("femaleCount ${isIncreasingWithZerosOnRight2(femaleCount)}");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data when the page is initialized
    fetchData();
  }

  // Function to fetch data
  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final snapshot = await FirebaseFirestore.instance
          .collection("Voting")
          .doc('votingRecords')
          .collection("hourlyRecord")
          .doc('${logindocId}')
          .get();

      if (snapshot.exists) {
        lastBoothRecord = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic>? lbr = lastBoothRecord;
        print(lbr);
        for (var temp in lbr!['hourlyRecord']!.keys) {
          maleCount[int.parse(temp)] =
              lastBoothRecord!['hourlyRecord']['$temp']['male'] ?? 0;
          femaleCount[int.parse(temp)] =
              lastBoothRecord!['hourlyRecord']['$temp']['female'] ?? 0;
          otherCount[int.parse(temp)] =
              lastBoothRecord!['twoHourRecord']['$temp']['other'] ?? 0;
          print(temp);
        }

        print("MaleCount $maleCount");
        print("FemaleCount $femaleCount");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
        _setTotalFromFirebase();
      });
    }
  }

  _setTotalFromFirebase() {
    totalCount = lastBoothRecord?['totalRecord']?['total']?.toString() ?? '';
    totalMale = lastBoothRecord?['totalRecord']?['male']?.toString() ?? "0";
    totalFemale = lastBoothRecord?['totalRecord']?['female']?.toString() ?? "0";
    totalOther = lastBoothRecord?['totalRecord']?['other']?.toString() ?? "0";
    totalCalculated =
        int.parse(totalMale) + int.parse(totalFemale) + int.parse(totalOther);
  }

  @override
  Widget build(BuildContext context) {
    double mqw = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;
    // String totalCount =
    //     lastBoothRecord?['totalRecord']?['total']?.toString() ?? '';
    // totalCount = (male + female + other).toString();

    // String totalMale =
    //     lastBoothRecord?['totalRecord']?['male']?.toString() ?? "";
    // String totalFemale =
    //     lastBoothRecord?['totalRecord']?['female']?.toString() ?? "";
    // int totalCountForController = int.parse(_totalMaleController.text) +
    //     int.parse(_totalFemaleController.text) +
    //     int.parse(_totalOtherController.text);
    // _totalVoteController.text = totalCountForController.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('1 घंटा रिकॉर्ड'),
        actions: [
          if (hourlyRecords.isNotEmpty || totalRecord.isNotEmpty)
            ElevatedButton(
              style: btnStyle(MediaQuery.of(context).size.width * 0.2,
                  MediaQuery.of(context).size.height * 0.04),
              onPressed: () {
                save();
              },
              child: const Text("SAVE"),
            ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 8),
                        Container(
                          // height: mqh * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(mqw * 0.01),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'कुल पु.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(height: 8),
                              Container(
                                width: mqw * 0.25,
                                // color: Colors.blue,
                                child: TextFormField(
                                  // controller: _totalMaleController,
                                  keyboardType: TextInputType.number,
                                  initialValue: totalMale,
                                  onChanged: (value) {
                                    setState(() {
                                      male = int.tryParse(value) ?? 0;
                                      totalRecord['male'] = male;
                                      totalMale = male.toString();
                                      totalCalculated = int.parse(totalMale) +
                                          int.parse(totalFemale) +
                                          int.parse(totalOther);
                                      print("totalCalculated $totalCalculated");
                                      totalRecord['total'] = totalCalculated;

                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          // height: mqh * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(mqw * 0.01),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'कुल म.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(height: 8),
                              Container(
                                width: mqw * 0.25,
                                // color: Colors.pink,
                                child: TextFormField(
                                  // controller: _totalFemaleController,
                                  keyboardType: TextInputType.number,
                                  initialValue: totalFemale,
                                  onChanged: (value) {
                                    setState(() {
                                      female = int.tryParse(value) ?? 0;
                                      totalRecord['female'] = female;
                                      totalFemale = female.toString();
                                      totalCalculated = int.parse(totalMale) +
                                          int.parse(totalFemale) +
                                          int.parse(totalOther);
                                      print("totalCalculated $totalCalculated");
                                      totalRecord['total'] = totalCalculated;

                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          // height: mqh * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(mqw * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'कुल अ.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(height: 8),
                              Container(
                                width: mqw * 0.25,
                                // color: Colors.red,
                                child: TextFormField(
                                  // controller: _totalOtherController,
                                  keyboardType: TextInputType.number,
                                  initialValue: totalOther,
                                  onChanged: (value) {
                                    setState(() {
                                      other = int.tryParse(value) ?? 0;
                                      totalRecord['other'] = other;
                                      totalOther = other.toString();

                                      totalCalculated = int.parse(totalMale) +
                                          int.parse(totalFemale) +
                                          int.parse(totalOther);
                                      print("totalCalculated $totalCalculated");
                                      totalRecord['total'] = totalCalculated;

                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: mqh * 0.12,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(mqw * 0.01),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'कुल मतदाता',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: mqh * 0.01),
                              Center(
                                child: Container(
                                  width: mqw * 0.25,
                                  // color: Colors.amber,
                                  child: Center(
                                      child: Text(
                                    totalCalculated.toString(),
                                    style: TextStyle(
                                        fontSize: mqw * 0.044,
                                        fontWeight: FontWeight.bold),
                                  )),

                                  // TextFormField(
                                  //   // controller: _totalVoteController,
                                  //   keyboardType: TextInputType.number,
                                  //   initialValue: totalCount,
                                  //   // enabled: false,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       total = int.tryParse(value) ?? 0;
                                  //       totalRecord['total'] = total;
                                  //     });
                                  //   },
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: const Text(
                            "समय",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "पुरुष",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "महिला",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "अन्य",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Data list or loading indicator
                  // isLoading
                  //     ? const Center(child: CircularProgressIndicator())
                  //     :
                  (lastBoothRecord != null)
                      ? Container(
                          width: mqh * 0.8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: hourTitle.length,
                            itemBuilder: (context, index) {
                              final hour = hourTitle[index];

                              Map<String, dynamic>? boothRecord =
                                  lastBoothRecord;
                              // print(boothRecord!['hourlyRecord'].runtimeType);
                              // print(boothRecord['hourlyRecord'].length - 1 >= index
                              //     ? (boothRecord['hourlyRecord'] ?? 0)
                              //     : 0);

                              int _maleCount = 0;
                              int _femaleCount = 0;
                              int _othercount = 0;
                              try {
                                _maleCount = (boothRecord!['hourlyRecord']
                                        ['$index']['male']) ??
                                    0;
                              } catch (e) {}
                              try {
                                _femaleCount = (boothRecord!['hourlyRecord']
                                        ['$index']['female']) ??
                                    0;
                              } catch (e) {}

                              try {
                                _othercount = (boothRecord!['twoHourRecord']
                                        ['$index']['other']) ??
                                    0;
                              } catch (e) {}

                              TextEditingController maleController =
                                  TextEditingController(
                                      text: _maleCount.toString());
                              TextEditingController femaleController =
                                  TextEditingController(
                                      text: _femaleCount.toString());

                              TextEditingController otherController =
                                  TextEditingController(
                                      text: _othercount.toString());
                              return _voteData(maleController, femaleController,
                                  otherController, hour);
                            },
                          ),
                        )
                      : const Center(child: Text('Error fetching data')),
                ],
              ),
            ),
    );
  }

  Widget _voteData(
      TextEditingController maleController,
      TextEditingController femaleController,
      TextEditingController otherController,
      String hour) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.22,
            child: Text(
              hour,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.036,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              // controller: maleController,
              initialValue: maleController.text,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                updateHourlyRecord(hour, 'male', int.tryParse(value) ?? 0);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              // controller: femaleController,
              initialValue: femaleController.text,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                updateHourlyRecord(hour, 'female', int.tryParse(value) ?? 0);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: otherController.text,
              onChanged: (value) {
                updateHourlyRecord(hour, 'other', int.tryParse(value) ?? 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class _EditHourlyRecordState extends State<EditHourlyRecord> {
//   Map<String, Map<String, int>> hourlyRecords = {};
//   List hourTitle = [
//     '07:08 AM',
//     '08:09 AM',
//     '09:10 AM',
//     '10:11 AM',
//     '11:12 PM',
//     '12:01 PM',
//     '01:02 PM',
//     '02:03 PM',
//     '03:04 PM',
//     '04:05 PM',
//     '05:06 PM',
//     '06:07 PM',
//     '07:08 PM',
//     '08:09 PM',
//     '09:10 PM',
//     '10:11 PM'
//   ];

//   ScrollController _scrollController = ScrollController();

//   Map<String, dynamic> lastBoothRecord = {};

//   save() {
//     Map oneValue = {'female': 30, 'male': 10, 'other': '10'};
//     Map<Object, Object> updateValue = {'hourlyRecord.1': oneValue};
//     try {
//       FirebaseFirestore.instance
//           .collection("Voting")
//           .doc('votingRecords')
//           .collection("hourlyRecord")
//           .doc('3ezWWq1RfkrtLYNmrX5u')
//           .update(updateValue);
//       print("Succefully updated");
//     } catch (e) {
//       print("Error $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double mqw = MediaQuery.of(context).size.width;
//     double mqh = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('प्रति घंटा रिकॉर्ड'),
//         actions: [
//           ElevatedButton(
//               style: btnStyle(mqw * 0.2, mqh * 0.04),
//               onPressed: () {
//                 save();
//               },
//               child: const Text("SAVE")),
//           SizedBox(
//             width: mqw * 0.02,
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 children: [
//                   Container(
//                       width: mqw * 0.2,
//                       child: const Text("समय",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold))),
//                   const SizedBox(width: 10),
//                   const Expanded(
//                       child: Text("पुरुष",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold))),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                       child: Text("महिला",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold))),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                       child: Text("अन्य",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold))),
//                 ],
//               ),
//             ),
//             Container(
//               height: mqh * 0.76, // Adjust the height as needed
//               // width: 500,
//               child: FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection("Voting")
//                       .doc('votingRecords')
//                       .collection("hourlyRecord")
//                       .doc('3ezWWq1RfkrtLYNmrX5u')
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                       // return ListView.builder(
//                       //     controller: _scrollController,
//                       //     scrollDirection: Axis.vertical,
//                       //     itemCount: hourTitle.length,
//                       //     itemBuilder: (context, index) {
//                       //       var hour = hourTitle[index];
//                       //       int maleCount =
//                       //           lastBoothRecord['hourlyRecord'].length - 1 >=
//                       //                   index
//                       //               ? (int.parse(
//                       //                   (lastBoothRecord['hourlyRecord'][index]
//                       //                           ['male']) ??
//                       //                       0))
//                       //               : 0;
//                       //       int femaleCount =
//                       //           lastBoothRecord['hourlyRecord'].length - 1 >=
//                       //                   index
//                       //               ? (int.parse(
//                       //                   (lastBoothRecord['hourlyRecord'][index]
//                       //                           ['female']) ??
//                       //                       0))
//                       //               : 0;
//                       //       TextEditingController maleController =
//                       //           TextEditingController(
//                       //               text: maleCount.toString());
//                       //       TextEditingController femaleController =
//                       //           TextEditingController(
//                       //               text: femaleCount.toString());

//                       //       return _voteData(
//                       //           maleController, femaleController, hour);
//                       //     });
//                     }
//                     if (snapshot.hasError || !snapshot.hasData) {
//                       return const Center(
//                           child: Text('Error fetching order details'));
//                     }
//                     final boothRecord =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     print(boothRecord);
//                     lastBoothRecord = boothRecord;

//                     return ListView.builder(
//                       controller: _scrollController,
//                       scrollDirection: Axis.vertical,
//                       itemCount: hourTitle.length,
//                       itemBuilder: (context, index) {
//                         var hour = hourTitle[index];
//                         print("hourlyRecordtype");
//                         print(boothRecord['hourlyRecord'].runtimeType);
//                         print(boothRecord['hourlyRecord'].length - 1 >= index
//                             ? (boothRecord['hourlyRecord'] ?? 0)
//                             : 0);
//                         int maleCount =
//                             boothRecord['hourlyRecord'].length - 1 >= index
//                                 ? ((boothRecord['hourlyRecord']['$index']
//                                         ['male']) ??
//                                     0)
//                                 : 0;
//                         int femaleCount =
//                             boothRecord['hourlyRecord'].length - 1 >= index
//                                 ? ((boothRecord['hourlyRecord']['$index']
//                                         ['female']) ??
//                                     0)
//                                 : 0;
//                         TextEditingController maleController =
//                             TextEditingController(text: maleCount.toString());
//                         TextEditingController femaleController =
//                             TextEditingController(text: femaleCount.toString());

//                         return _voteData(
//                             maleController, femaleController, hour);

//                         // return Padding(
//                         //   padding: const EdgeInsets.symmetric(
//                         //       horizontal: 16, vertical: 8),
//                         //   child: Column(
//                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                         //     children: [
//                         //       Row(
//                         //         children: [
//                         //           Container(
//                         //             width: mqw * 0.2,
//                         //             child: Text(hour,
//                         //                 style: const TextStyle(
//                         //                     fontSize: 18,
//                         //                     fontWeight: FontWeight.bold)),
//                         //           ),
//                         //           const SizedBox(width: 10),
//                         //           Expanded(
//                         //             child: TextFormField(
//                         //               controller: maleController,
//                         //               // keyboardType: TextInputType.number,
//                         //               onChanged: (value) {
//                         //                 updateHourlyRecord(hour, 'male',
//                         //                     int.tryParse(value) ?? 0);
//                         //               },
//                         //             ),
//                         //           ),
//                         //           const SizedBox(width: 16),
//                         //           Expanded(
//                         //             child: TextFormField(
//                         //               keyboardType: TextInputType.number,
//                         //               controller: femaleController,
//                         //               onChanged: (value) {
//                         //                 updateHourlyRecord(hour, 'female',
//                         //                     int.tryParse(value) ?? 0);
//                         //               },
//                         //             ),
//                         //           ),
//                         //           const SizedBox(width: 16),
//                         //           Expanded(
//                         //             child: TextFormField(
//                         //               keyboardType: TextInputType.number,
//                         //               onChanged: (value) {
//                         //                 updateHourlyRecord(hour, 'other',
//                         //                     int.tryParse(value) ?? 0);
//                         //               },
//                         //             ),
//                         //           ),
//                         //         ],
//                         //       ),
//                         //       const Divider()
//                         //     ],
//                         //   ),
//                         // );
//                       },
//                     );
//                   }),
//             ),
//             // Submit button
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Implement submit logic here
//             //     print(hourlyRecords);
//             //   },
//             //   child: const Text('Submit'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   void updateHourlyRecord(String hour, String gender, int count) {
//     if (!hourlyRecords.containsKey(hour)) {
//       hourlyRecords[hour] = {};
//     }
//     hourlyRecords[hour]![gender] = count;
//     print(hourlyRecords);
//     // setState(() {
//     //   if (!hourlyRecords.containsKey(hour)) {
//     //     hourlyRecords[hour] = {};
//     //   }
//     //   hourlyRecords[hour]![gender] = count;
//     //   print(hourlyRecords);
//     // });
//   }

//   Widget _voteData(TextEditingController maleController,
//       TextEditingController femaleController, String hour) {
//     double mqw = MediaQuery.of(context).size.width;
//     double mqh = MediaQuery.of(context).size.height;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: mqw * 0.2,
//                 child: Text(hour,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextFormField(
//                   // controller: maleController,
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     updateHourlyRecord(hour, 'male', int.tryParse(value) ?? 0);
//                   },
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   // controller: femaleController,
//                   onChanged: (value) {
//                     updateHourlyRecord(
//                         hour, 'female', int.tryParse(value) ?? 0);
//                   },
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     updateHourlyRecord(hour, 'other', int.tryParse(value) ?? 0);
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const Divider()
//         ],
//       ),
//     );
//   }
// }
