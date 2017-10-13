class GeoQueryEventListener {

    void Function(String key, List<double> location) _onKeyEntered;
    void Function(String key) _onKeyExited;
    void Function(String key, List<double> location) _onKeyMoved;
    void Function() _onGeoQueryReady;
    void Function(String error) _onGeoQueryError;

    GeoQueryEventListener(this._onKeyEntered, this._onKeyExited, this._onKeyMoved, this._onGeoQueryReady, this._onGeoQueryError);

    void onKeyEntered(String key, List<double> location) {
        _onKeyEntered(key, location);
    }
    void onKeyExited(String key) {
        _onKeyExited(key);
    }
    void onKeyMoved(String key, List<double> location) {
        _onKeyMoved(key, location);
    }
    void onGeoQueryReady() {
        _onGeoQueryReady();
    }
    void onGeoQueryError(String error) {
        _onGeoQueryError(error);
    }

}
