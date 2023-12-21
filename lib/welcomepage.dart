import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelplan/homepage.dart';
import 'package:travelplan/mainapp.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/welcomepicture.png",
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 45, right: 45),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Plan Your",
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.w300,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Travel Trip",
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.w300,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    text:
                        "Welcome to TravelPlan, where the world becomes your playground and every destination holds the promise of a new adventure.",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.offAll(MainApp(),
                            transition: Transition.rightToLeft);
                      },
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 93, 87, 142),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Let's Go",
                                style: GoogleFonts.playfairDisplay(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                weight: 3.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
