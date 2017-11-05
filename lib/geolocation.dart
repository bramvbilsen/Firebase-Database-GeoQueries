import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:geohash/geohash.dart';


import './geoquery.dart';

class FirebaseGeoLocation {

    DatabaseReference _dbRef;
    String _path;
    GeoQuery query;
    HashSet<GeoQuery> queries = new HashSet();

    FirebaseGeoLocation(this._path) {
        _dbRef = FirebaseDatabase.instance.reference().child(path);
    }

    String get path => this._path;

    Future<Null> setLocation(String key, List<double> position) {
        if (position[0] > 90 || position[0] < -90) {
            throw new ArgumentError.value(position[0], "latitude", "The latitude argument has to be a double between -90 and 90 (inclusive)");
        }
        if (position[1] > 180 || position[1] < -180) {
            throw new ArgumentError.value(position[1], "longitude", "The longitude argument has to be a double between -180 and 180 (inclusive)");
        }
        return _dbRef.child(key).set(<String, dynamic>{
            "hash": Geohash.encode(position[0], position[1]),
            "loc": position
        });
    }

    Future<List<double>> getLocation(String key) {
        return _dbRef.child(key).once().then((DataSnapshot snap) {
            List<double> loc = snap.value["loc"];
            return loc;
        });
    }

    Future<Null> removeLocation(String key) {
        return _dbRef.child(key).remove();
    }

    GeoQuery addGeoQuery(List<double> center, double radius) {
        GeoQuery query = new GeoQuery(_path, center, radius);
        queries.add(query);
        return query;
    }

    void removeGeoQuery(GeoQuery query) {
        if (!queries.contains(query))
            throw new ArgumentError("The query you are trying to delete is not attached to this object!");
        query.removeGeoQueryEventListener();
        queries.remove(query);
    }
    
}
