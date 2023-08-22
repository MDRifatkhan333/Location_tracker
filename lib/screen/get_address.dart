import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapLocation extends StatefulWidget {
  const MapLocation({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<MapLocation> {
  String location = 'Get Location!, Press Button';
  String address = 'search';
  String street = 'Street Name';
  String locality = 'City locality';
  String subLocality = 'State subLocality';
  String postalCode = 'Zip postalCode';
  String subAdministrativeArea = 'SA Area Name';
  String administrativeArea = 'A_Area Name';
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

  TextEditingController _drivercontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Map Location'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Get Location!, Press Button',
              style: TextStyle(color: Colors.black, fontSize: 16),
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

            ElevatedButton(
              onPressed: () async {
                Position position = await _getGeoLocationPosition();
                location =
                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                getAddressFromLatLong(position);
                setState(() {});
                // ignore: use_build_context_synchronously
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('location'),
                    content: SingleChildScrollView(
                      //scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 8.0),
                            child: Row(
                              children: [
                                // const Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       'Street',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //     Text(
                                //       'Locality',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //     Text(
                                //       'Sub Locality',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //     Text(
                                //       'Postal Code',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //     Text(
                                //       'Sub Administrative Area',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //     Text(
                                //       'Administrative Area',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //     Text(
                                //       'Country',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //   ],
                                // ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      street,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(locality,
                                        style: const TextStyle(fontSize: 16)),
                                    Text(subLocality,
                                        style: const TextStyle(fontSize: 16)),
                                    Text(postalCode,
                                        style: const TextStyle(fontSize: 16)),
                                    Text(subAdministrativeArea,
                                        style: const TextStyle(fontSize: 16)),
                                    Text(administrativeArea,
                                        style: const TextStyle(fontSize: 16)),
                                    Text(country,
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _drivercontroller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your Name',
                              labelText: 'Name',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('driverLocation')
                              .add({
                            'lat': location.split(',')[0],
                            'long': location.split(',')[1],
                            'AdministrativeArea': administrativeArea,
                            'Country': country,
                            'Locality': locality,
                            'Postal_Code': postalCode,
                            'SubAdministrativeArea': subAdministrativeArea,
                            'SubLocality': subLocality,
                            'Street': street,
                            'DriverName': _drivercontroller.text,
                          });
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Get Location'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     print(location);
            //     print(location.split(',')[1]);
            //     FirebaseFirestore.instance.collection('User_Location').add({
            //       'latitude': location.split(',')[0],
            //       'longitude': location.split(',')[1],
            //     });
            //   },
            //   child: const Text('Sent Address'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       top: 15.0, left: 20, right: 20, bottom: 8.0),
            //   child: Row(
            //     children: [
            //       const Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Street',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           Text(
            //             'Locality',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           Text(
            //             'Sub Locality',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           Text(
            //             'Postal Code',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           Text(
            //             'Sub Administrative Area',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           Text(
            //             'Administrative Area',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           Text(
            //             'Country',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //         ],
            //       ),
            //       const Spacer(),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             street,
            //             style: const TextStyle(fontSize: 16),
            //           ),
            //           Text(locality, style: const TextStyle(fontSize: 16)),
            //           Text(subLocality, style: const TextStyle(fontSize: 16)),
            //           Text(postalCode, style: const TextStyle(fontSize: 16)),
            //           Text(subAdministrativeArea,
            //               style: const TextStyle(fontSize: 16)),
            //           Text(administrativeArea,
            //               style: const TextStyle(fontSize: 16)),
            //           Text(country, style: const TextStyle(fontSize: 16)),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
