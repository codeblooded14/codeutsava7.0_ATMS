import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceryapp/pages/productPage.dart';

class VendorsPage extends StatefulWidget {
  final String product;

  VendorsPage(this.product);

  @override
  _VendorsPageState createState() => _VendorsPageState(product);
}

class _VendorsPageState extends State<VendorsPage> {
  final String product;

  _VendorsPageState(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$product Sellers'), // Use the product name in the title
      ),
      body: VendorList(productName: product),
    );
  }
}

class VendorList extends StatefulWidget {
  final String productName;

  VendorList({required this.productName});

  @override
  _VendorListState createState() => _VendorListState(productName: productName);
}

class _VendorListState extends State<VendorList> {
  final String productName;

  _VendorListState({required this.productName});

  @override
  Widget build(BuildContext context) {
    print(productName);
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Find the productID for the given productName
        String productID = '';
        for (var doc in productSnapshot.data!.docs) {
          if (doc['productName'] == productName) {
            productID = doc['productID'];
            break;
          }
        }

        if (productID.isEmpty) {
          double generateRandomPrice() {
            final double minPrice = 50.0; // Minimum price in INR
            final double maxPrice = 500.0; // Maximum price in INR
            double randomPrice =
                minPrice + Random().nextDouble() * (maxPrice - minPrice);

            // Round the price to two decimal places
            return double.parse(randomPrice.toStringAsFixed(2));
          }

          List<VendorListItem> dummyEntries = List.generate(7, (index) {
            return VendorListItem(
              vendorName: 'Vendor $index',
              starRating: 3.5, // Replace with a dummy star rating
              price: generateRandomPrice(), // Generate a random INR price
            );
          });

          return ListView(
            children: dummyEntries,
          );
        }

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('vendors').get(),
          builder: (context, vendorSnapshot) {
            if (vendorSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<String> vendorNames = [];

            for (var doc in vendorSnapshot.data!.docs) {
              // Check if this vendor has the product in their productCatalog
              List<dynamic> productCatalog = doc['productCatalog'];
              for (var productEntry in productCatalog) {
                if (productEntry['productID'] == productID) {
                  vendorNames.add(doc['name']);
                  break;
                }
              }
            }

            if (vendorNames.isEmpty) {
              return Center(child: Text('No vendors sell this product'));
            }

            return ListView(
              children: vendorNames
                  .map((vendorName) => VendorListItem(
                        vendorName: vendorName,
                        starRating: 4.5, // Replace with actual star rating
                        price: 5.99, // Replace with actual price
                      ))
                  .toList(),
            );
          },
        );
      },
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
