import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class productBuyPage extends StatelessWidget {
  final String vendorName;
  final double starRating;
  final double price;

  productBuyPage({
    required this.vendorName,
    required this.starRating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: [
                Image.asset(
                  'lib/images/avocado.png',
                  height: 200,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '$starRating',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Avocado',
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28, color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Avocado, a nutrient-rich fruit, is prized for its creamy texture and healthy fats. A versatile ingredient in salads, sandwiches, and more.',
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20, color: Colors.black),
                ),
                const SizedBox(
                  height: 170,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.green,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                              child: Text(
                                '$price Rs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: IconButton(
                                    onPressed: () {
                                      ;
                                    },
                                    icon: Icon(Icons.add_shopping_cart_sharp),
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class VendorListItem extends StatelessWidget {
  final String vendorName;
  final double starRating;
  final double price;

  VendorListItem({
    required this.vendorName,
    required this.starRating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vendorName),
      subtitle: Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          Text('$starRating'),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$price Rs'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => productBuyPage(
                    vendorName: vendorName,
                    starRating: starRating,
                    price: price,
                  ),
                ),
              );
            },
            child: Text('Buy'),
          ),
        ],
      ),
    );
  }
}
