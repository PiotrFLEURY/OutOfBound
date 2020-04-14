class SettingsService {
  int _boundary;
  bool _enableAlerts = false;

  // ignore: unnecessary_getters_setters
  set boundary(int boundary) {
    _boundary = boundary;
  }

  // ignore: unnecessary_getters_setters
  int get boundary {
    return _boundary;
  }

  // ignore: unnecessary_getters_setters
  set enableAlerts(bool enableAlerts) {
    _enableAlerts = enableAlerts;
  }

  // ignore: unnecessary_getters_setters
  bool get enableAlerts {
    return _enableAlerts;
  }
}
