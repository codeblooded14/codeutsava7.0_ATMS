import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/grocery_item_tile.dart';
import '../model/cart_model.dart';
import 'cart_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'vendorsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Icon(
            Icons.location_on,
            color: Colors.grey[700],
          ),
        ),
        title: Text(
          'Raipur, Chhatisgarh',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CartPage();
            },
          ),
        ),
        child: const Icon(Icons.shopping_bag),
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Good morning,'),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Let's order fresh items for you",
                style: GoogleFonts.notoSerif(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(),
            ),
            const SizedBox(height: 24),
            TabBar(
              // Tabs for perishable and non-perishable goods
              tabs: [
                Tab(
                    child: Text(
                  'Perishable Goods',
                  style: TextStyle(color: Colors.black),
                )),
                Tab(
                    child: Text(
                  'Non-Perishable Goods',
                  style: TextStyle(color: Colors.black),
                )),
              ],
            ),
            Expanded(
              child: TabBarView(
                // Tab views for perishable and non-perishable goods
                children: [
                  // Perishable Goods Tab
                  Consumer<CartModel>(
                    builder: (context, value, child) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: value.shopItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.2,
                        ),
                        itemBuilder: (context, index) {
                          // You can filter perishable goods here based on your data
                          return GroceryItemTile(
                            itemName: value.shopItems[index][0],
                            itemPrice: value.shopItems[index][1],
                            imagePath: value.shopItems[index][2],
                            color: value.shopItems[index][3],
                            onPressed: () =>
                                Provider.of<CartModel>(context, listen: false)
                                    .addItemToCart(index),
                          );
                        },
                      );
                    },
                  ),
                  Consumer<CartModel>(
                    builder: (context, value, child) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: value.shopItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.2,
                        ),
                        itemBuilder: (context, index) {
                          // You can filter perishable goods here based on your data
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VendorsPage(value
                                          .shopItems[index]
                                      [0]), // Replace with dynamic product name
                                ),
                              );
                            },
                            child: GroceryItemTile(
                              itemName: value.shopItems[index][0],
                              itemPrice: value.shopItems[index][1],
                              imagePath: value.shopItems[index][2],
                              color: value.shopItems[index][3],
                              onPressed: () =>
                                  Provider.of<CartModel>(context, listen: false)
                                      .addItemToCart(index),
                            ),
                          );
                        },
                      );
                    },
                  )
                  // Non-Perishable Goods Tab
                  // Add a similar GridView.builder for non-perishable goods
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
