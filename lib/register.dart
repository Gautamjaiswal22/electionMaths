import 'package:chunavganit/homePage.dart';
import 'package:chunavganit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _boothNumberController = TextEditingController();
  TextEditingController _boothAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  saveId(var id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Docid $id");
    await prefs.setString('docId', id);
    logindocId = id;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _nameController.dispose();
    _boothNumberController.dispose();
    _boothAddressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, save data to Firestore or perform other actions

      // Now you can save `userData` to Firestore or perform other actions
      // print(userData);

      // Optionally, navigate to another page after successful signup
    }
  }

  save() async {
    bool check = _mobileController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _boothNumberController.text.isNotEmpty &&
        _boothAddressController.text.isNotEmpty;

    if (check) {
      Map<String, dynamic> updateValue = {
        'mobile': _mobileController.text,
        'name': _nameController.text,
        'boothNo': _boothNumberController.text,
        'boothAddress': _boothAddressController.text
      };

      try {
        String id = '';

        await FirebaseFirestore.instance
            .collection("Voting")
            .doc('votingRecords')
            .collection("hourlyRecord")
            .add(updateValue)
            .then((value) async {
          id = value.id;
          print("value.id ${value.id}");
          await saveId(id);
        });
        print(id);
        print("Succefully updated");
        setState(() {});
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
        // Navigator.of(context).pop();
      } catch (e) {
        print("Error $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Enter All Details");
    }
  }

  @override
  Widget build(BuildContext context) {
    double mqw = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign Up'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: mqh,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          "assets/icon.png",
                          height: mqh * 0.16,
                        ),
                        Text("चुनाव गणित",
                            style: TextStyle(
                                fontSize: mqw * 0.1,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        // You can add additional validation rules for mobile number
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        // You can add additional validation rules for name
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _boothNumberController,
                      decoration: InputDecoration(labelText: 'Booth Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the booth number';
                        }
                        // You can add additional validation rules for booth number
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _boothAddressController,
                      decoration: InputDecoration(labelText: 'Booth Address'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the booth address';
                        }
                        // You can add additional validation rules for booth address
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Check if the button is pressed or disabled, and return the appropriate color
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white
                                  .withOpacity(0.8); // Adjust opacity if needed
                            } else if (states
                                .contains(MaterialState.disabled)) {
                              return Colors
                                  .grey; // Adjust disabled color if needed
                            }
                            return Colors.white; // Default button color
                          },
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Check if the button is pressed or disabled, and return the appropriate color
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xffE15524)
                                  .withOpacity(0.8); // Adjust opacity if needed
                            } else if (states
                                .contains(MaterialState.disabled)) {
                              return Colors
                                  .grey; // Adjust disabled color if needed
                            }
                            return Color(0xffE15524); // Default button color
                          },
                        ),
                        minimumSize: MaterialStateProperty.all(Size(
                            double.infinity, 60)), // Set the desired height

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5.0), // Set border radius here
                          ),
                        ),
                      ),
                      onPressed: () {
                        save();
                        // _submitForm();
                      },
                      child: Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
