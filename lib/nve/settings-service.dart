class SettingsService {
  int _boundary;
  bool _enableAlerts = false;

  set boundary(int boundary) {
    _boundary = boundary;
  }

  int get boundary {
    return _boundary;
  }

  set enableAlerts(bool enableAlerts) {
    _enableAlerts = enableAlerts;
  }

  bool get enableAlerts {
    return _enableAlerts;
  }
}