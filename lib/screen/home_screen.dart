
import './cart_screen.dart';
import './catagory_protect.dart';
import './contact_screen.dart';
import './detile_page.dart';
import './profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/featured_container.dart';
import './about_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food.dart';
import 'search.dart';
import 'package:provider/provider.dart';
import '../provider/myprovider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Food food;
  var userImage;
  var uid;

  //  @override
  //  void initState() {
  //   super.initState();
  //  MyProvider provider = Provider.of<MyProvider>(context, listen: false);
  //   provider.fetchAllFoods();
  
  //  }

  void getUserImage() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
  }

  Widget plzza({String foodImage, String foodName, Function whenPreesed}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: whenPreesed,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height * 0.2 + 20,
              width: MediaQuery.of(context).size.width * 0.3 + 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    foodImage,
                    height: MediaQuery.of(context).size.height * 0.1 + 10,
                  ),
                  Text(
                    foodName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget circle() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            minRadius: 50,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              maxRadius: 45,
              backgroundImage: NetworkImage(userImage),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'How You upset',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'stomach?',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.5 - 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchBarA(),
              );
            },
            child: Container(
              height: 60,
              child: ListTile(
                trailing: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Want to search anything',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget icon() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.category,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget listTile({String name, IconData icon, Function whenPreesed}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8.5),
      child: Container(
        child: ListTile(
          onTap: whenPreesed,
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Container(
              child: Text(
                name,
                style: TextStyle(fontSize: 17, color: Color(0xff2b2b2b)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget callingPizza() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2 + 50,
      //  height: MediaQuery.of(context).size.height * 0.1 + 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Row(
            children: <Widget>[
              plzza(
                whenPreesed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CatagoryProtect(),
                    ),
                  );
                },
                foodImage: 'images/pizza1.png',
                foodName: 'pastas',
              ),
              plzza(
                foodImage: 'images/salads.png',
                foodName: 'GreenTea',
                whenPreesed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CatagoryProtect(),
                    ),
                  );
                },
              ),
              plzza(
                foodImage: 'images/salads.png',
                foodName: 'GreenTea',
                whenPreesed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CatagoryProtect(),
                    ),
                  );
                },
              ),
              plzza(
                foodImage: 'images/salads.png',
                foodName: 'GreenTea',
                whenPreesed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CatagoryProtect(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget callingBottomPart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          FeaturedContainer(
            foodImage: food.foodImage,
            foodName: food.foodName,
            foodPrice: food.foodPrice,
            foodType: food.foodType,
            foodRating: food.foodRating,
            whenPreesd: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetilePage(
                    foodImage: food.foodImage,
                    foodName: food.foodName,
                    foodPrice: food.foodPrice,
                    foodType: food.foodType,
                  ),
                ),
              );
            },
          ),
          FeaturedContainer(
            foodImage: food.foodImage,
            foodName: food.foodName,
            foodPrice: food.foodPrice,
            foodType: food.foodType,
            foodRating: food.foodRating,
            whenPreesd: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetilePage(
                    foodImage: food.foodImage,
                    foodName: food.foodName,
                    foodPrice: food.foodPrice,
                    foodType: food.foodType,
                  ),
                ),
              );
            },
          ),
          FeaturedContainer(
            foodImage: food.foodImage,
            foodName: food.foodName,
            foodPrice: food.foodPrice,
            foodType: food.foodType,
            foodRating: food.foodRating,
            whenPreesd: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetilePage(
                    foodImage: food.foodImage,
                    foodName: food.foodName,
                    foodPrice: food.foodPrice,
                    foodType: food.foodType,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget viewAll() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Featured',
            style: TextStyle(
                fontSize: 23,
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CatagoryProtect()),
              );
            },
            child: Text(
              'View All',
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerHeader() {
    return Container(
      height: 80,
      child: DrawerHeader(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'tesste',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calingListTile() {
    return Container(
      color: Colors.red,
      child: Drawer(
        child: SafeArea(
          child: Container(
            color: Color(0xfff8f8f8),
            child: ListView(
              children: <Widget>[
                drawerHeader(),
                listTile(
                    icon: Icons.home,
                    name: 'Home',
                    whenPreesed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                      FocusScope.of(context).unfocus();
                    }),
                listTile(
                    icon: Icons.add_shopping_cart,
                    name: 'Cart',
                    whenPreesed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    }),
                listTile(
                  icon: Icons.location_on,
                  name: 'Address',
                ),
                listTile(
                  icon: Icons.notifications_none,
                  name: 'Notifications',
                ),
                listTile(
                  icon: Icons.perm_identity,
                  name: 'Profile',
                  whenPreesed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
                listTile(
                  icon: Icons.perm_identity,
                  name: 'Orders',
                ),
                Divider(
                  color: Color(0xffe5dddd),
                ),
                listTile(
                  icon: Icons.info_outline,
                  name: 'About',
                  whenPreesed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ),
                    );
                  },
                ),
                listTile(
                  icon: Icons.phone,
                  name: 'Contact',
                  whenPreesed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Contact()));
                  },
                ),
                Divider(
                  color: Color(0xffe5dddd),
                ),
                listTile(
                  icon: Icons.exit_to_app,
                  name: 'Logout',
                  whenPreesed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context, listen: false);
    provider.fetchAllFoods();
    getUserImage();
    return Scaffold(
      drawer: calingListTile(),
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: () {})
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff0f1f2),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection("Food").snapshots(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              food = Food(
                foodRating: snapShot.data.documents[0]["foodRating"],
                foodImage: snapShot.data.documents[0]["foodImage"],
                foodName: snapShot.data.documents[0]["foodName"],
                foodPrice: snapShot.data.documents[0]["foodPrice"],
                foodType: snapShot.data.documents[0]["foodType"],
              );
              return StreamBuilder(
                stream: Firestore.instance.collection("user").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var myDocuments = snapshot.data.documents;
                  myDocuments.forEach(
                    (checkDocument) {
                      if (uid == checkDocument["userId"]) {
                        userImage = checkDocument["UserImage"];
                      }
                    },
                  );

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              callingPizza(),
                              viewAll(),
                              callingBottomPart(),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2 + 40,
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            children: <Widget>[
                              circle(),
                            ],
                          ),
                        ),
                        search(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
