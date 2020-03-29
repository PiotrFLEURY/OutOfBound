class SettingsService {
  double _boundary = 42.0;
  bool _enableAlerts = false;

  get boundary => _boundary;

  set boundary(value) {
    _boundary = value;
  }

  get enableAlerts => _enableAlerts;

  set enableAlerts(value) {
    _enableAlerts = value;
  }
}
