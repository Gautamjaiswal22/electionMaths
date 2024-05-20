import 'package:chunavganit/main.dart';
import 'package:chunavganit/voteDataCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TwoHourRecord extends StatefulWidget {
  const TwoHourRecord({super.key});

  @override
  State<TwoHourRecord> createState() => _TwoHourRecordState();
}

class _TwoHourRecordState extends State<TwoHourRecord> {
  Map<String, Map<String, int>> twoHourRecords = {};
  List hourTitle = [
    '07 से 09 AM',
    '09 से 11 AM',
    '11 से 01 PM',
    '01 से 03 PM',
    '03 से 05 PM',
    '05 से 07 PM',
    '07 से 09 PM',
    '09 से 11 PM'
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
                          const SizedBox(width: 10),
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
                    height: mqh * 0.8,
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
                          int totalCount =
                              lastBoothRecord['totalRecord']?['total'] ?? 0;
                          int totalMale =
                              lastBoothRecord['totalRecord']?['male'] ?? 0;
                          int totalFemale =
                              lastBoothRecord['totalRecord']?['female'] ?? 0;
                          int totalOther =
                              lastBoothRecord['totalRecord']?['other'] ?? 0;

                          return ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: hourTitle.length,
                            itemBuilder: (context, index) {
                              var hour = hourTitle[index];
                              print("twoHourRecordtype");

                              int maleCount = boothRecord['twoHourRecord']
                                      ?['$index']?['male'] ??
                                  0;
                              int femaleCount = boothRecord['twoHourRecord']
                                      ?['$index']?['female'] ??
                                  0;
                              int otherCount = boothRecord['twoHourRecord']
                                      ?['$index']?['other'] ??
                                  0;

                              return VoteDataCard(
                                maleCount: maleCount,
                                femaleCount: femaleCount,
                                otherCount: otherCount,
                                hour: hour,
                                index: index,
                                totalMale: totalMale,
                                totalFemale: totalFemale,
                                totalOther: totalOther,
                                totalVote: totalCount,
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
