import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelplan/citycard.dart';
import 'package:travelplan/data/citydata.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<CityData> cityList = [];
  late List<CityData> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchCitiesFromFirestore();
  }

  Future<void> fetchCitiesFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('CityData').get();

    cityList = querySnapshot.docs.map((doc) {
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

    setState(() {
      filteredList = List.from(cityList);
    });
  }

  void filterCities(String query) {
    setState(() {
      filteredList = cityList.where((city) {
        return city.city.toLowerCase().contains(query.toLowerCase()) ||
            city.country.toLowerCase().contains(query.toLowerCase()) ||
            city.continent.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Map<String, List<CityData>> groupByContinent() {
    return filteredList.fold(<String, List<CityData>>{}, (acc, city) {
      acc.update(city.continent, (value) {
        value.add(city);
        return value;
      }, ifAbsent: () => [city]);
      return acc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Search Destination",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w300,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 126, 117, 208),
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    onChanged: (value) => filterCities(value),
                    decoration: InputDecoration(
                      hintText: 'Search by name, continent, or city...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white, // Background color
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 20),
              child: filteredList.isEmpty
                  ? Center(child: Text('No matching cities found'))
                  : ListView(
                      children: [
                        for (final continentCities
                            in groupByContinent().entries)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  continentCities.key,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 9 / 9,
                                ),
                                itemCount: continentCities.value.length,
                                itemBuilder: (context, index) {
                                  final city = continentCities.value[index];
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
                            ],
                          ),
                        SizedBox(
                          height: 100,
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
