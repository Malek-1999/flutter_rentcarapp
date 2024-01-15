import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentcarapp/Views/availableCars.dart';
import 'package:flutter_rentcarapp/constants/Toast.dart';
import 'package:flutter_rentcarapp/models/Review.dart';
import '../widgets/bookCar.dart';
import '../widgets/carWidget.dart';
import '../widgets/dealerWidget.dart';

import 'package:flutter_rentcarapp/models/databaseHandler.dart';
import '../constants/constants.dart';
import '../constants/data.dart';
import 'package:google_fonts/google_fonts.dart';

class Showroom extends StatefulWidget {
  const Showroom({super.key});

  @override
  State<Showroom> createState() => _ShowroomState();
}

class _ShowroomState extends State<Showroom> {
  List<NavigationItem> navigationItems = getNavigationItemList();
  late NavigationItem selectedItem;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController offersController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  List<Car> cars = getCarList();

  List<Review> reviews = []; // Declare a list to hold reviews
  List<dynamic> dealers1 = getDealerList(); //list<DealerS>

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedItem = navigationItems[0];
    });
  }

  // Method to show the form for adding a new dealer
  Future<void> _showAddDealerForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: nameController,
                  // Controller or logic to capture the dealer's name
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Review'),
                  controller: imageController,
                  // Controller or logic to capture the dealer's offers
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Note /10'),
                  controller: offersController,
                  keyboardType: TextInputType.number,
                  // Controller or logic to capture the dealer's offers
                ),
                // Add more TextFields for other dealer details if needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Logic to add the new dealer to Firestore
                // Retrieve the values from the TextFields and call the method to add the dealer

                String dealerName = nameController.text;
                int dealerOffers = int.parse(offersController.text);
                String dealerImage = imageController.text;

                _addDealerToFirestore(
                    context, dealerName, dealerOffers, dealerImage);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addDealerToFirestore(
      BuildContext context, String name, int offers, String image) {
    try {
      Review newReview = Review(name: name, note: offers, review: image);

      // Call the DatabaseHandler method to add the Review to Firestore
      DatabaseHandler.createReview(newReview).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        print('Error adding Review: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add Review.'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } catch (e) {
      print('Error in _addReviewToFirestore: $e');
    }
    // Close the dialog
    Navigator.of(context).pop();
  }

  void deleteReviewAndDocument(String id, int index) async {
    // Call the deleteReview method from DatabaseHelper
    await DatabaseHandler.deleteReview(id);

    setState(() {
    reviews.removeWhere((review) => review.id == id);
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Car Rental App",
          style: GoogleFonts.mulish(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.logout_rounded,
                color: kPrimaryColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.only(left: 30),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 24, left: 16),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 24,
                      ),
                    ))),
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  //DEALS :
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TOP DEALS",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                          ),
                          Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: kPrimaryColor,
                              )
                            ],
                          )
                        ]),
                  ),
                  Container(
                    height: 280,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: buildDeals(),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AvailableCars()));
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16, right: 16, left: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            )),
                        padding: const EdgeInsets.all(24),
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Available Cars",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                                Text("Long and short term",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              height: 50,
                              width: 50,
                              child: Center(
                                  child: Icon(
                                Icons.arrow_forward_ios,
                                color: kPrimaryColor,
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //STATIC Dealers:
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOP DEALERS",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "View all",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 150,
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: buildDealers(),
                    ),
                  ),

                  //FIREBASE COMMENTS
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TOP REVIEWS",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showAddDealerForm(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    // You can also adjust other button properties here
                                    // textStyle: TextStyle(color: Colors.white),
                                    // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    'Add yours',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                  //FIRESTORE DATA :
                  Container(
                      height: 400,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: StreamBuilder<List<Review>>(
                          stream: DatabaseHandler.getdealers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(), // Show a loading indicator
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    'Error: ${snapshot.error}'), // Show any error that occurred
                              );
                            } else {
                              if (snapshot.hasData) {
                                final reviews = snapshot.data!;
                                if (reviews.isEmpty) {
                                  return const Center(
                                    child: Text(
                                        'No reviews found'), // Inform when the list is empty
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                          child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 16.0), // Set margin
                                        child: ListTile(
                                          title: Text(
                                            reviews[index].name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                            ),
                                          ),
                                          subtitle: Text(
                                            reviews[index].review,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                              backgroundColor: kPrimaryColor,
                                              child: Icon(
                                                Icons.car_rental_sharp,
                                                color: Colors.white,
                                              )),
                                          trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${reviews[index].note} /10',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    final reviewId =
                                                        reviews[index].id;
                                                    if (reviewId != null) {
                                                      DatabaseHandler
                                                          .deleteReview(
                                                              reviewId);
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Color.fromARGB(
                                                        255,
                                                        173,
                                                        18,
                                                        7), // Change color as needed
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ));
                                    },
                                  );
                                }
                              } else {
                                return const Center(
                                  child: Text(
                                      'No data yet'), // Handle the case when there's no data
                                );
                              }
                            }
                          }))
                ],
              )),
        ))
      ]),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildNavigationItems(),
        ),
      ),
    );
  }

  List<Widget> buildDeals() {
    List<Widget> list = [];
    for (var i = 0; i < cars.length; i++) {
      list.add(GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookCar(car: cars[i])),
            );
          },
          child: buildCar(cars[i], i)));
    }
    return list;
  }
  /*
  List<Widget> buildDealers() {
    List<Widget> list = [];
    for (var i = 0; i < dealers.length; i++) {
      list.add(buildDealer(dealers[i], i));
    }
    return list;
  }*/

  List<Widget> buildDealers() {
    List<Widget> list = [];
    for (var i = 0; i < dealers1.length; i++) {
      list.add(buildDealer(dealers1[i], i));
    }
    return list;
  }

  List<Widget> buildNavigationItems() {
    List<Widget> list = [];
    for (var i = 0; i < navigationItems.length; i++) {
      list.add(buildNavigationItem(navigationItems[i]));
    }
    return list;
  }

  Widget buildNavigationItem(NavigationItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = item;
        });
      },
      child: Container(
        width: 50,
        child: Stack(
          children: <Widget>[
            selectedItem == item
                ? Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColorShadow,
                      ),
                    ),
                  )
                : Container(),
            Center(
              child: Icon(
                item.iconData,
                color: selectedItem == item ? kPrimaryColor : Colors.grey[400],
                size: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
