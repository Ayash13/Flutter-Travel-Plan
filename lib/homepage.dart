import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelplan/citycard.dart';
import 'package:travelplan/citydetailpage.dart';
import 'package:travelplan/data/citydata.dart';

import 'package:travelplan/loginpage.dart';
import 'package:travelplan/mainapp.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CityData>> cities;
  late User? _user;
  bool showAll = false;
  bool isFeatured = false;
  @override
  void initState() {
    super.initState();
    cities = fetchCitiesFromFirestore();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<List<CityData>> fetchCitiesFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('CityData').get();

    List<CityData> cityList = querySnapshot.docs.map((doc) {
      return CityData(
        doc['City'] ?? '',
        doc['Country'] ?? '',
        doc['ImageUrl'] ?? '',
        doc['Price'] ?? '',
        doc['Description'] ?? '',
        doc.id,
        doc['Continent'] ?? '',
      );
    }).toList();

    return cityList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _signOut(context);
          },
          icon: Icon(
            Icons.logout_rounded,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: Center(
          child: Text(
            "TravelPlan",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w300,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(
                _user?.photoURL ??
                    "https://i.pinimg.com/564x/ef/d1/1a/efd11a0b56f5f8b95609996796af22b2.jpg",
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFeatured = false;
                  });
                },
                child: Text(
                  "Popular",
                  style: GoogleFonts.poppins(
                    fontWeight: isFeatured ? FontWeight.w500 : FontWeight.bold,
                    fontSize: 15,
                    color: isFeatured ? Colors.black : Color(0xff403A7A),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFeatured = true;
                  });
                },
                child: Text(
                  "Featured",
                  style: GoogleFonts.poppins(
                    fontWeight: isFeatured ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15,
                    color: isFeatured ? Color(0xff403A7A) : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          isFeatured ? Featured() : Popular()
        ],
      ),
    );
  }

  Expanded Featured() {
    return Expanded(
        child: ListView(
      children: [
        FutureBuilder<List<CityData>>(
          future: cities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              List<CityData> limitedCityData = snapshot.data!.take(6).toList();
              return CarouselSlider(
                options: CarouselOptions(
                  autoPlayAnimationDuration: Duration(seconds: 3),
                  autoPlayInterval: Duration(seconds: 4),
                  height: MediaQuery.of(context).size.height * 0.69,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.85,
                ),
                items: limitedCityData.map((city) {
                  return CityCard(
                    country: city.country,
                    city: city.city,
                    imageUrl: city.imageURL,
                    price: city.price,
                    description: city.description,
                    docId: city.docId,
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    ));
  }

  Expanded Popular() {
    return Expanded(
      child: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          FutureBuilder<List<CityData>>(
            future: cities,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                List<CityData> limitedCityData =
                    snapshot.data!.take(4).toList();
                return CarouselSlider(
                  options: CarouselOptions(
                    autoPlayAnimationDuration: Duration(seconds: 3),
                    autoPlayInterval: Duration(seconds: 4),
                    height: 200,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.85,
                  ),
                  items: limitedCityData.map((city) {
                    return CityCard(
                      country: city.country,
                      city: city.city,
                      imageUrl: city.imageURL,
                      price: city.price,
                      description: city.description,
                      docId: city.docId,
                    );
                  }).toList(),
                );
              }
            },
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recomeneded",
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(
                    showAll ? "Minimum" : "Show All",
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //display card from firestore as item
          FutureBuilder<List<CityData>>(
            future: cities,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (showAll ? snapshot.data!.length : 4 / 2).ceil(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 9 / 9,
                              ),
                              itemCount: index * 2 + 2 <= snapshot.data!.length
                                  ? 2
                                  : snapshot.data!.length % 2,
                              itemBuilder: (context, subIndex) {
                                final dataIndex = index * 2 + subIndex;
                                final CityData city = snapshot.data![dataIndex];
                                return CityCard(
                                  country: city.country,
                                  city: city.city,
                                  imageUrl: city.imageURL,
                                  price: city.price,
                                  description: city.description,
                                  docId: city.docId,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
          SizedBox(
            height: 120,
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then(
            (value) => Get.offAll(
              LoginPage(),
            ),
          );
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
