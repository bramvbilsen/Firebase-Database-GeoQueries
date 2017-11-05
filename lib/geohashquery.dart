part of './geoquery.dart';

class _GeoHashQuery {
  
  static String adj(String geohash, String direction) {
    // based on github.com/davetroy/geohash-js
    geohash = geohash.toLowerCase();
    direction = direction.toLowerCase();

    String base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

    if (geohash.length == 0) return "meh";
    if ('nsew'.indexOf(direction) == -1) return "meh";

    Map neighbour = {
      "n": [
        'p0r21436x8zb9dcf5h7kjnmqesgutwvy',
        'bc01fg45238967deuvhjyznpkmstqrwx'
      ],
      "s": [
        '14365h7k9dcfesgujnmqp0r2twvyx8zb',
        '238967debc01fg45kmstqrwxuvhjyznp'
      ],
      "e": [
        'bc01fg45238967deuvhjyznpkmstqrwx',
        'p0r21436x8zb9dcf5h7kjnmqesgutwvy'
      ],
      "w": [
        '238967debc01fg45kmstqrwxuvhjyznp',
        '14365h7k9dcfesgujnmqp0r2twvyx8zb'
      ],
    };
    Map border = {
      "n": ['prxz', 'bcfguvyz'],
      "s": ['028b', '0145hjnp'],
      "e": ['bcfguvyz', 'prxz'],
      "w": ['0145hjnp', '028b'],
    };

    String lastCh = geohash[geohash.length - 1]; // last character of hash
    String parent =
        geohash.substring(0, geohash.length - 1); // hash without last character

    int type = geohash.length % 2;

    // check for edge-cases which don't share common prefix
    if (border[direction][type].indexOf(lastCh) != -1 && parent != '') {
      parent = adj(parent, direction);
    }

    // append letter for direction to parent
    return parent + base32[neighbour[direction][type].indexOf(lastCh)];
  }
  
}