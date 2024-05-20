import 'package:chunavganit/homePage.dart';
import 'package:chunavganit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Voting")
              .doc('votingRecords')
              .collection("hourlyRecord")
              .doc('${logindocId}')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Error fetching order details'));
            }
            final boothRecord = snapshot.data!.data() as Map<String, dynamic>;
            String name = boothRecord['name'];
            String boothNo = boothRecord['boothNo'];
            String boothAddress = boothRecord['boothAddress'];

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // UserAccountsDrawerHeader(
                //   accountName: Text(name),
                //   accountEmail: Text('YourEmail@example.com'),
                //   // currentAccountPicture: CircleAvatar(
                //   //     // backgroundImage: AssetImage('assets/profile_picture.png'),
                //   //     ),
                // ),
                SizedBox(
                  height: 50,
                ),
                BoothInfoBox(
                    boothKramank: boothNo,
                    adhikariName: name,
                    pata: boothAddress),
                // ListTile(
                //   leading: const Icon(Icons.home),
                //   title: const Text('Home'),
                //   onTap: () {
                //     // Handle onTap for Home
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.settings),
                //   title: const Text('Settings'),
                //   onTap: () {
                //     // Handle onTap for Settings
                //   },
                // ),
                // Add more list tiles as needed

                // Footer
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.bottomCenter,
                  // color: Colors.grey[300],
                  child: const Text(
                    'Made With ❤️ By Gautam Jaiswal\n gautamjaiswal252@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
