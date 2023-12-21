import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelplan/notesdetailpage.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              "Travel Plan",
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Color(0xff403A7A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: FutureBuilder<QuerySnapshot>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'No data available',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ));
                } else {
                  // Extracting data from documents
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  final travelData = documents.map((doc) {
                    return {
                      'city': doc['city'],
                      'country': doc['country'],
                      'days': doc['days'],
                      'image': doc['image'],
                      'content': doc['content'],
                      'price': doc['price'],
                      'docId': doc.id,
                    };
                  }).toList();

                  // Use travelData for further processing or display
                  // Example: Displaying the data in a ListView
                  return ListView.builder(
                    itemCount: travelData.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(travelData[index]
                            ['docId']), // Unique key for each item
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          final docId = travelData[index]['docId'];
                          final currentUser = _auth.currentUser;

                          if (currentUser != null) {
                            final userId = currentUser.uid;
                            await _firestore
                                .collection('users')
                                .doc(userId)
                                .collection('notes')
                                .doc(docId)
                                .delete();
                          }
                        },
                        background: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, right: 30.0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: Color.fromARGB(255, 232, 110, 99),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 50.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              NotesDetailPaage(
                                country: travelData[index]['country'],
                                days: travelData[index]['days'],
                                image: travelData[index]['image'],
                                content: travelData[index]['content'],
                                city: travelData[index]['city'],
                                price: travelData[index]['price'],
                                docId: travelData[index]['docId'],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              left: 30,
                              right: 30,
                            ),
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 40, top: 20, bottom: 20, right: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      travelData[index]['country'],
                                      style: GoogleFonts.playfairDisplay(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.timelapse),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          travelData[index]['days'] + " Days",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<QuerySnapshot> _getUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      return await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .get();
    } else {
      throw Exception('User not authenticated');
    }
  }
}
