import 'package:flutter/material.dart';
import 'package:flutter_firebase_database_geolocation/geolocation.dart';
import 'package:flutter_firebase_database_geolocation/geoquery.dart';
import 'package:flutter_firebase_database_geolocation/geoqueryeventlistener.dart';

void main() {
  runApp(new MaterialApp(
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  FirebaseGeoLocation geoLocation = new FirebaseGeoLocation("locations");
  GeoQuery query;
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new RaisedButton(
            child: new Text("Set location"),
            onPressed: () {
              geoLocation.setLocation("Lidl", [50.888495, 4.700948]).then((Null res) => print("success"));
            },
          ),
          new RaisedButton(
            child: new Text("Remove location"),
            onPressed: () {
              geoLocation.removeLocation("Lidl").then((Null result) {
                print("Location removed");
              });
            },
          ),
          new RaisedButton(
            child: new Text("Get location"),
            onPressed: () {
              geoLocation.getLocation("Lidl").then((List<double> snap) {
                print("Got location");
                print(snap);
              });
            },
          ),
          new RaisedButton(
            child: new Text("Create GeoQuery for Kot with 5KM radius"),
            onPressed: () {
              query = geoLocation.addGeoQuery([50.888161, 4.704021], 5.0);
            },
          ),
          new RaisedButton(
            child: new Text("Create listener for Kot query"),
            onPressed: () {
              query.addGeoQueryEventListener(new GeoQueryEventListener(
                (String key, List<double> loc) {
                  print("");
                  print("###############");
                  print("Key entered!");
                  print("---");
                  print("Key: " + key);
                  print("Location: " + loc.toString());
                }, (String key) {
                  print("");
                  print("###############");
                  print("Key exited!");
                  print("---");
                  print("Key: " + key);
                }, (String key, List<double> loc) {
                  print("");
                  print("###############");
                  print("Key moved!");
                  print("---");
                  print("Key: " + key);
                  print("Location: " + loc.toString());
                }, () {

                },(String err) {

                }
              ));
            },
          ),
          new RaisedButton(
            child: new Text("Remove query"),
            onPressed: () {
              geoLocation.removeGeoQuery(query);
            },
          ),
        ],
      ),
    );
  }
}