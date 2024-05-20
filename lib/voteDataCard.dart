import 'package:chunavganit/homePage.dart';
import 'package:flutter/material.dart';

class VoteDataCard extends StatefulWidget {
  final int maleCount;
  final int femaleCount;
  final int otherCount;
  final String hour;
  final int index;
  final int totalMale;
  final int totalFemale;
  final int totalOther;
  final int totalVote;
  final String boothNo;
  final String boothAddress;
  final String senderName;
  VoteDataCard(
      {super.key,
      required this.maleCount,
      required this.femaleCount,
      required this.hour,
      required this.index,
      required this.totalMale,
      required this.totalFemale,
      required this.otherCount,
      required this.totalOther,
      required this.boothNo,
      required this.boothAddress,
      required this.senderName,
      required this.totalVote});

  @override
  State<VoteDataCard> createState() => _VoteDataCardState();
}

class _VoteDataCardState extends State<VoteDataCard> {
  String malepercentage = '';
  String femalePercentage = '';
  String otherPercentage = '';
  String totalPercentage = '';
  int voteCount = 0;

  String message = '';
  genMessage() {
    message = '''
समय : ${widget.hour},
पुरुष : ${widget.maleCount},
पुरुष % :$malepercentage %,
महिला : ${widget.femaleCount},
महिला % : $femalePercentage %,
अन्य : 0
''';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    malepercentage =
        ((widget.maleCount / widget.totalMale) * 100).toStringAsFixed(2);
    femalePercentage =
        ((widget.femaleCount / widget.totalMale) * 100).toStringAsFixed(2);
    otherPercentage =
        ((widget.otherCount / widget.totalOther) * 100).toStringAsFixed(2);
    voteCount = widget.maleCount + widget.femaleCount + widget.otherCount;
    totalPercentage = ((voteCount / widget.totalVote) * 100).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    double mqw = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;

    return Container(
      color: widget.index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: mqw * 0.22,
                  child: Text(widget.hour,
                      style: TextStyle(
                          fontSize: mqw * 0.036, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Container(
                  // decoration: BoxDecoration(border: Border(left: BorderSide(), right: BorderSide())),
                  width: mqw * 0.2,
                  child: Text(
                    widget.maleCount.toString(),
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
                const SizedBox(width: 16),
                Container(
                    width: mqw * 0.2,
                    child: Text(
                      widget.femaleCount.toString(),
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
                const SizedBox(width: 16),
                Container(
                    width: mqw * 0.2,
                    child: Text(
                      "${widget.otherCount}",
                      style: TextStyle(color: Colors.blue),
                    )),
                Container(
                    width: mqw * 0.2,
                    child: Text(
                      otherPercentage,
                      style: TextStyle(color: Colors.blue),
                    )),
                const SizedBox(width: 16),
                Container(
                    width: mqw * 0.2,
                    child: Text(
                      "${voteCount}",
                      style: TextStyle(color: Colors.blue),
                    )),
                Container(
                    width: mqw * 0.2,
                    child: Text(
                      totalPercentage,
                      style: TextStyle(color: Colors.blue),
                    )),
                IconButton(
                    color: Colors.green,
                    onPressed: () {
                      String message = '''

बूथ क्रमांक : ${widget.boothNo} ,
पता : ${widget.boothAddress}
नाम : ${widget.senderName} ,
समय : ${widget.hour},
पुरुष : ${widget.maleCount},
पुरुष % :$malepercentage %,
महिला : ${widget.femaleCount},
महिला % : $femalePercentage %,
अन्य : ${widget.otherCount},
अन्य %: ${otherPercentage} % ,
कुल : $voteCount ,
कुल % : $totalPercentage %
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
    // };
  }
}
