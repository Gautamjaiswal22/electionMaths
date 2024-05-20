import 'package:chunavganit/main.dart';
import 'package:chunavganit/voteDataCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HourlyRecord extends StatefulWidget {
  const HourlyRecord({super.key});

  @override
  State<HourlyRecord> createState() => _HourlyRecordState();
}

class _HourlyRecordState extends State<HourlyRecord> {
  Map<String, Map<String, int>> hourlyRecords = {};
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

  ScrollController _scrollController = ScrollController();

  Map<String, dynamic> lastBoothRecord = {};
  @override
  Widget build(BuildContext context) {
    double mqw = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: mqh * 0.9, // Adjust the height as needed
              width: mqw * 3,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      width: mqw * 3,
                      child: Row(
                        children: [
                          Container(
                              width: mqw * 0.22,
                              child: const Text("समय",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 10),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("पुरुष",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 10),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("पुरुष %",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 16),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("महिला",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 10),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("महिला %",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 16),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("अन्य",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 16),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("अन्य %",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 16),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("कुल",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(width: 16),
                          Container(
                              width: mqw * 0.2,
                              child: const Text("कुल %",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: mqh * 0.82,
                    child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("Voting")
                            .doc('votingRecords')
                            .collection("hourlyRecord")
                            .doc('${logindocId}')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Center(
                                child: Text('Error fetching order details'));
                          }
                          final boothRecord =
                              snapshot.data!.data() as Map<String, dynamic>;
                          print(boothRecord);
                          lastBoothRecord = boothRecord;

                          return ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: hourTitle.length,
                            itemBuilder: (context, index) {
                              var hour = hourTitle[index];
                              print("hourlyRecordtype");

                              int maleCount = 0;
                              int femaleCount = 0;
                              int otherCount = 0;
                              try {
                                maleCount = (boothRecord['hourlyRecord']
                                        ['$index']['male']) ??
                                    0;
                              } catch (e) {}
                              try {
                                femaleCount = (boothRecord['hourlyRecord']
                                        ['$index']['female']) ??
                                    0;
                              } catch (e) {}
                              try {
                                otherCount = (boothRecord['hourlyRecord']
                                        ['$index']['other']) ??
                                    0;
                              } catch (e) {}

                              int totalCount =
                                  lastBoothRecord['totalRecord']?['total'] ?? 0;

                              int totalMale =
                                  lastBoothRecord['totalRecord']?['male'] ?? 0;
                              int totalFemale = lastBoothRecord['totalRecord']
                                      ?['female'] ??
                                  0;
                              int totalOther =
                                  lastBoothRecord['totalRecord']?['other'] ?? 0;
                              // TextEditingController maleController =
                              //     TextEditingController(
                              //         text: maleCount.toString());
                              // TextEditingController femaleController =
                              //     TextEditingController(
                              //         text: femaleCount.toString());
                              return VoteDataCard(
                                maleCount: maleCount,
                                femaleCount: femaleCount,
                                hour: hour,
                                index: index,
                                totalMale: totalMale,
                                totalFemale: totalFemale,
                                totalVote: totalCount,
                                otherCount: otherCount,
                                totalOther: totalOther,
                                boothNo: lastBoothRecord['boothNo'],
                                boothAddress: lastBoothRecord['boothAddress'],
                                senderName: lastBoothRecord['name'],
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
