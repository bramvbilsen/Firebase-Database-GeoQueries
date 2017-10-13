import 'dart:math';
import 'dart:collection';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'geoqueryeventlistener.dart';
import 'package:geohash/geohash.dart';

part './geohashquery.dart';

class GeoQuery {

  DatabaseReference _dbRef;
  List<double> _center;
  double _radius;
  String _path;
	String _geoHash;

	HashSet<StreamSubscription> subscriptions = new HashSet();
  
  GeoQuery(String path, List<double> center, double radius) {
		this._center = center;
		this._radius = radius;
		this._geoHash = Geohash.encode(center[0], center[1]);
		this._path = path;
    _dbRef = FirebaseDatabase.instance.reference().child(path);
  }

  List<double> get center => _center;
  double get radius => _radius;
  String get path => _path;

  void addGeoQueryEventListener(GeoQueryEventListener listener) {

		String newPrecisionHash;
		List neighbors;

		if (radius <= 0.6) { // Geohash precision ~6
			newPrecisionHash = _geoHash.substring(0, 5);
		} else if (radius <= 2.5) { // Geohash precision ~5
			newPrecisionHash = _geoHash.substring(0, 4);
		} else if (radius <= 20) { // Geohash precision ~4
			newPrecisionHash = _geoHash.substring(0, 3);
		} else if (radius <= 78) { // Geohash precision ~3
			newPrecisionHash = _geoHash.substring(0, 2);
		}

		neighbors = [
			_GeoHashQuery.adj(newPrecisionHash, "n"),
			_GeoHashQuery.adj(newPrecisionHash, "e"),
			_GeoHashQuery.adj(newPrecisionHash, "s"),
			_GeoHashQuery.adj(newPrecisionHash, "w"),
			_GeoHashQuery.adj(_GeoHashQuery.adj(newPrecisionHash, 'n'), 'e'),
			_GeoHashQuery.adj(_GeoHashQuery.adj(newPrecisionHash, 's'), 'e'),
			_GeoHashQuery.adj(_GeoHashQuery.adj(newPrecisionHash, 's'), 'w'),
			_GeoHashQuery.adj(_GeoHashQuery.adj(newPrecisionHash, 'n'), 'w'),
		];

		for (int i = 0; i < 9; i++) {
			String hashToUse = i == 0 ? newPrecisionHash : neighbors[i-1]; // Use hash for appropriate location
			Query query = _dbRef.orderByChild("hash")
						.startAt(hashToUse)
						.endAt(hashToUse + "\uf8ff");
			subscriptions.add(query.onChildAdded.listen((Event e) {
				List<double> loc = e.snapshot.value["loc"];
				if (_distance(center[0], center[1], loc[0], loc[1], "K") <= radius) {
					listener.onKeyEntered(e.snapshot.key, loc);
				}
			}));
			subscriptions.add(query.onChildRemoved.listen((Event e) {
				List<double> loc = e.snapshot.value["loc"];
				print(loc);
				if (_distance(center[0], center[1], loc[0], loc[1], "K") <= radius) {
					listener.onKeyExited(e.snapshot.key);
				}
			}));
			subscriptions.add(query.onChildChanged.listen((Event e) {
				List<double> loc = e.snapshot.value["loc"];
				print(loc);
				if (e.snapshot.value["hash"].toString().startsWith(hashToUse)) {
					if (_distance(center[0], center[1], loc[0], loc[1], "K") <= radius) {
						listener.onKeyMoved(e.snapshot.key, loc);
					}
				} else {
					listener.onKeyExited(e.snapshot.key);
				}
			}));
		}

  }

  void removeGeoQueryEventListener() {
  	subscriptions.forEach((StreamSubscription sub) {
  		sub.cancel();
		});
  	subscriptions.clear();
	}

	double _distance(double lat1, double lon1, double lat2, double lon2, String unit) {
		double theta = lon1 - lon2;
		double dist = sin(_deg2rad(lat1)) * sin(_deg2rad(lat2)) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * cos(_deg2rad(theta));
		dist = acos(dist);
		dist = _rad2deg(dist);
		dist = dist * 60 * 1.1515;
		if (unit == "K") {
			dist = dist * 1.609344;
		} else if (unit == "N") {
			dist = dist * 0.8684;
		}

		return (dist);
	}

	double _deg2rad(double deg) {
		return (deg * PI / 180.0);
	}

	double _rad2deg(double rad) {
		return (rad * 180 / PI);
	}

}
