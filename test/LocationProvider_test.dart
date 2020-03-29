import 'package:OutOfBounds/pfy/LocationProvider.dart';
import 'package:OutOfBounds/pfy/services/NotificationService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';

// MOCKS
class MockLocationData extends Mock implements LocationData {}

class MockNotificationService extends Mock implements NotificationService {}

class MockGeoLocator extends Mock implements Geolocator {}

final geoLocator = MockGeoLocator();

void main() {
  setUp(() {
    final getIt = GetIt.instance;
    getIt.registerSingleton<NotificationService>(MockNotificationService());

    getIt.registerSingleton<Geolocator>(geoLocator);
  });
  test("description", () async {
    MockLocationData locationData = MockLocationData();

    final longitude = 0.0;
    final latitude = 0.0;
    when(locationData.longitude).thenAnswer((_) => longitude);
    when(locationData.latitude).thenAnswer((_) => latitude);
    when(geoLocator.placemarkFromCoordinates(latitude, longitude))
        .thenAnswer((_) async => [Placemark()]);

    LocationProvider provider = LocationProvider();
    await provider.onLocationChanged(locationData);

    expect(provider.currentLocationAddress != null, true);
  });
  tearDown(() {
    //NOTHING TO DO
  });
}
