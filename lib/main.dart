import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'screen/address.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String location = 'Null, Press Button';
  String address = 'search';
  String street = 'Street Name';
  String locality = 'City locality';
  String subLocality = 'State subLocality';
  String postalCode = 'Zip postalCode';
  String subAdministrativeArea = 'subAdministrativeArea Name';
  String administrativeArea = 'administrativeArea Name';
  String country = 'Country Name';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //permission = await Geolocator.requestPermission();
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    street = placemarks.reversed.last.street.toString();
    locality = placemarks.reversed.last.locality.toString();
    subLocality = placemarks.reversed.last.subLocality.toString();
    postalCode = placemarks.reversed.last.postalCode.toString();
    subAdministrativeArea =
        placemarks.reversed.last.subAdministrativeArea.toString();
    administrativeArea = placemarks.reversed.last.administrativeArea.toString();
    country = placemarks.reversed.last.country.toString();

    Placemark place = placemarks[0];
    address =
        '${place.street},${place.locality},${place.subLocality}, ${place.postalCode},${place.subAdministrativeArea},${place.administrativeArea},   ${place.country}  ';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Coordinates Points',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              location,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'ADDRESS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(address),
            Text(country),
            ElevatedButton(
              onPressed: () async {
                Position position = await _getGeoLocationPosition();
                location =
                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                getAddressFromLatLong(position);
                setState(() {});
              },
              child: const Text('Get Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyAddress()));
              },
              child: const Text('Sent Address'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 20, right: 20, bottom: 8.0),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Street',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Locality',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Sub Locality',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Postal Code',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Sub Administrative Area',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Administrative Area',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Country',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        street,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(locality, style: const TextStyle(fontSize: 16)),
                      Text(subLocality, style: const TextStyle(fontSize: 16)),
                      Text(postalCode, style: const TextStyle(fontSize: 16)),
                      Text(subAdministrativeArea,
                          style: const TextStyle(fontSize: 16)),
                      Text(administrativeArea,
                          style: const TextStyle(fontSize: 16)),
                      Text(country, style: const TextStyle(fontSize: 16)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
