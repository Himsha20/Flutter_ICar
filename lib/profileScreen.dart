import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icar/HomeScreen.dart';
import 'package:icar/functions.dart';
import 'package:icar/globalvar.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'dart:io' show Platform;

class ProfileScreen extends StatefulWidget {
  String? sellerId;
  ProfileScreen({this.sellerId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth =FirebaseAuth.instance;
    String? userName;
    String? userNumber;
    String? carPrice;
    String? carModel;
    String? carLocation;
    String? carColor;
    String? description;
    String? urlImage;
    QuerySnapshot? cars;

    carMethods carObj = new carMethods();

  Future showDialogForUpdateData(selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
              "Update Data",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Bebas',
                  letterSpacing: 2.0),

            ),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Your Name'),
                  onChanged: (value){
                    this.userName = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Your Phone Number'),
                  onChanged: (value){
                    this.userNumber = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Price'),
                  onChanged: (value){
                    this.carPrice = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Name'),
                  onChanged: (value){
                    this.carModel = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Color'),
                  onChanged: (value){
                    this.carColor = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Location'),
                  onChanged: (value){
                    this.carLocation = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Description'),
                  onChanged: (value){
                    this.description = value;
                  },
                ),

                TextField(
                  decoration: InputDecoration(hintText: 'Enter Image URL'),
                  onChanged: (value){
                    this.urlImage = value;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Update Now'),
                onPressed:(){
                  Navigator.pop(context);
                  Map<String,dynamic> carData ={
                    'userName':this.userName,
                    'userNumber':this.userNumber,
                    'carPrice':this.carPrice,
                    'carModel':this.carModel,
                    'carColor':this.carColor,
                    'carLocation':this.carLocation,
                    'description':this.description,
                    'urlImage':this.urlImage,
                  };
                  carObj.updateData(selectedDoc,carData).then((value){
                    print('Data Updated Successfully');
                    Navigator.push(context,MaterialPageRoute(builder:(context) => HomeScreen()));
                  }).catchError((onError){
                    print(onError);
                  });
                },

              ),
            ],
          );
        }
    );
  }

    Widget _buildBackButton(){
      return IconButton(
        onPressed: (){
          Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        },
        icon: Icon(Icons.arrow_back,color:Colors.white),
      );
    }

    Widget _buildUserImage(){
      return Container(
        width:50,
        height:40,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(adUserImageUrl,),
            fit: BoxFit.fill,
          ),
        ),
      );
    }

    getResults(){
      FirebaseFirestore.instance.collection('cars')
          .where('uId',isEqualTo: widget.sellerId)

          .get()
          .then((results){
            setState(() {
              cars = results;
              adUserName = cars!.docs[0]['userName'];
              adUserImageUrl = cars!.docs[0]['imgPro'];
            });
      });
    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults();
  }

  Widget showCarsList()  {
    var cars = this.cars;

    if(cars != null){
      return ListView.builder(
        itemBuilder:(context,i){
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                    onTap: (){
                      Route newRoute = MaterialPageRoute(builder:(_) => ProfileScreen(sellerId: cars.docs[i]['uId'],),);
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(cars.docs[i]['imgPro']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  title: GestureDetector(
                    onTap: (){
                      Route newRoute = MaterialPageRoute(builder:(_)=>ProfileScreen(sellerId: cars.docs[i]['uId'],));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Text(cars.docs[i]['userName']),
                  ),
                  subtitle: GestureDetector(
                    onTap: (){
                      Route newRoute = MaterialPageRoute(builder:(_)=>ProfileScreen(sellerId: cars.docs[i]['uId'],));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            cars.docs[i]['carLocation'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.0,),
                        Icon(Icons.location_pin,color: Colors.grey,),
                      ],
                    ),
                  ),
                  trailing:
                  cars.docs[i]['uId'] == userId ?
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(cars.docs[i]['uId'] == userId){
                            showDialogForUpdateData(cars.docs[i].id);
                          }
                        },
                        child: Icon(Icons.edit_outlined),
                      ),
                      SizedBox(width: 20.0,),
                      GestureDetector(
                        onDoubleTap: (){
                          if(cars.docs[i]['uId'] ==userId){
                            carObj.deleteData(cars.docs[i].id);
                            Navigator.push(context,MaterialPageRoute(builder:(BuildContext c)=>HomeScreen()));
                          }
                        },
                        child: Icon(Icons.delete_forever_sharp),
                      ),
                    ],
                  )
                      :Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(16.0),
                  child: Image.network(cars.docs[i]['urlImage'],fit: BoxFit.fill,),
                ),
                Padding(padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                      '\$' +cars.docs[i]['carPrice'],
                      style:TextStyle(
                        fontFamily:"Bebas",
                        letterSpacing:2.0,
                        fontSize:24,
                      )
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_car),
                          Padding(padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              child: Text(cars.docs[i]['carModel']),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.watch_later_outlined),
                          Padding(padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              child: Text(tAgo.format((cars.docs[i]['time']).toDate())),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_car),
                          Padding(padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              child: Text(cars.docs[i]['carColor']),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.watch_later_outlined),
                          Padding(padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              child: Text(cars.docs[i]['userNumber']),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Text(
                    cars.docs[i]['description'],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color:Colors.blueAccent.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),

              ],
            ),
          );
        },
        itemCount: cars.docs.length,
        padding: EdgeInsets.all(8.0),
      );
    }
    else{
      return Text('Loading...');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screeWidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return Scaffold(
      appBar: AppBar(
          leading: _buildBackButton(),
        title: Row(
          children: [
            _buildUserImage(),
            SizedBox(width: 10,),
            Text(adUserName),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.redAccent,
              ],
              begin: const FractionalOffset(0.0,0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            ),

          ),
        ),
      ),
      body: Center(
        child: Container(
          width:Platform.isAndroid || Platform.isIOS ? _screeWidth  : _screeWidth*.6,
          child:  showCarsList(),
        ),
      ),
    );
  }
}
