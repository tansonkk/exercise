import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/GoogleMap/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'models/CustomMarker.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  //data about adding marker
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  final Set<Marker> _markers = {};
  Marker? _selectedMarker;
  MarkerId? _selectedMarkerId;
  final Set<CustomMarker> _customMarkers = {};
  // CustomMarker? _selectedCustomMarker;
  List<LatLng> polylinePoints = [];

  void getPolylinePoints() async {
    // print("Get polyline points");

    if (_markers.length < 2) {
      // print("At least two markers are required.");
      setState(() {
        polylinePoints.clear();
      });
      return;
    }

    final List<LatLng> routePoints = [];
    final List<Marker> markerList = _markers.toList();

    for (int i = 0; i < markerList.length - 1; i++) {
      LatLng origin = markerList[i].position;
      LatLng destination = markerList[i + 1].position;

      List<LatLng> segmentPoints =
          await LocationService().getDirection(origin, destination);
      routePoints.addAll(segmentPoints);
    }

    setState(() {
      polylinePoints = routePoints;
    });

    final Polyline _polyline = Polyline(
      // polyline id
      polylineId: const PolylineId("route"),
      // polyline points
      points: polylinePoints,
      // line width
      width: 3,
      // line color
      color: const Color.fromARGB(255, 32, 134, 184),
    );

    // Use _polyline for further processing or drawing on the map
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    await Geolocator.requestPermission();

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update map camera position
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15.5,
    )));

    // Add marker for current location
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('currentLoc'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPolylinePoints();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getTappedPosition(LatLng latLng) {
    setState(() {
      _selectedMarker = null;
    });

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Position'),
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _addMarker(latLng, _nameController);
                  Navigator.of(context).pop(); // Close the info window
                },
                child: const Text('Add to Markers'),
              ),
            ],
          ),
        );
      },
    );

    _positionController.text = '${latLng.latitude}, ${latLng.longitude}';
  }

  Future<void> _goToSearchPlace(Map<String, dynamic> place) async {
    final double lat = place['result']['geometry']['location']['lat'];
    final double lng = place['result']['geometry']['location']['lng'];
    // print("lay : " + lat.toString());
    // print("lng : " + lng.toString());

    final GoogleMapController controller = await mapController;
    print("zoom :");
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 18),
      ),
    );
  }

  void _addMarker(LatLng latLng, TextEditingController _nameController) async {
    final markerId = MarkerId((_markers.length + 1).toString());
    // print("markedId : " + markerId.toString());
    // print("markers.count : " + _markers.length.toString());
    late String duration = '';
    LatLng arm = const LatLng(0, 0);
    LatLng origin = latLng;
    late MarkerId armId = MarkerId((_markers.length).toString());
    String distance = '';

    if (_markers.isNotEmpty) {
      for (Marker marker in _markers) {
        // print("not match");
        if (marker.markerId == armId) {
          // print("arm position : " + arm.toString());
          // print(marker.markerId.toString());
          arm = marker.position;
        }
      }
      int durationInSeconds = await LocationService().getDuration(origin, arm);
      int durationInMins = (durationInSeconds / 60).toInt();
      int seconds = durationInSeconds - (durationInMins * 60);
      duration = "${durationInMins.toStringAsFixed(0)}m${seconds}s";
      // print(duration);

      double distanceInMeters = LocationService().getDistance(origin, arm);
      double distanceInKm = distanceInMeters / 1000;
      distance = "${distanceInKm.toStringAsFixed(2)} km";
    }
    final name = _nameController.text;
    var marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: "Location : $name",
        snippet: ' Duration : $duration \n Distance : $distance',
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Location : $name",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Duration : $duration'),
                    const SizedBox(height: 16.0),
                    Text('Distance : $distance'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => {
                            // Call function for button 1
                            completer(markerId),
                            Navigator.pop(context), // Close the dialog
                          },
                          child: const Text('complete'),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            // Call function for button 2
                            remove(markerId),
                            Navigator.pop(context), // Close the dialog
                          },
                          child: const Text('remove'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    final customMarker = CustomMarker(
      marker: marker,
      state: "on-going",
    );

    setState(() {
      _markers.add(marker);
      _customMarkers.add(customMarker);
      _selectedMarkerId = markerId;
    });
    getPolylinePoints();
  }

  void _deselectMarker() {
    setState(() {
      _selectedMarker = null;
    });
  }

  void _showInfoWindow(BuildContext context) {
    _nameController.clear();

    _positionController.text =
        '${_selectedMarker!.position.latitude}, ${_selectedMarker!.position.longitude}';

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Position'),
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _nameController.text.isNotEmpty
                    ? _addMarkerFromInfoWindow
                    : null,
                child: const Text('Add to Markers'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addMarkerFromInfoWindow() {
    final name = _nameController.text;
    final position = _positionController.text.split(', ');

    if (name.isNotEmpty && position.length == 2) {
      final lat = double.tryParse(position[0]);
      final lng = double.tryParse(position[1]);

      if (lat != null && lng != null) {
        final markerId = MarkerId('marker${_markers.length}');
        final marker = Marker(
          // markerId: markerId,
          markerId: MarkerId(markerId.toString()),
          position: LatLng(lat, lng),
        );

        setState(() {
          _markers.add(marker);
          _selectedMarker = null;
        });

        Navigator.of(context).pop(); // Close the info window
      }
    }
  }

  void completer(MarkerId id) {
    final DateTime now = DateTime.now();

    for (CustomMarker marker in _customMarkers) {
      if (marker.marker.markerId == id) {
        setState(() {
          _customMarkers.remove(marker.marker);
        });
        print(marker.state);
      }
    }
    for (Marker marker in _markers) {
      if (marker.markerId == id) {
        setState(() {
          _markers.remove(marker);

          // Create a new Marker with the updated icon
          _markers.add(Marker(
            markerId: marker.markerId,
            position: marker.position,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Completed location ",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          const Text("Completed at"),
                          Text(
                              "Date : ${now.year} - ${now.month} - ${now.day} "),
                          Text("Time : ${now.hour} - ${now.minute}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => {
                                  // Call function for button 2
                                  remove(marker.markerId),
                                  Navigator.pop(context), // Close the dialog
                                },
                                child: const Text('remove'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ));
          _customMarkers.add(CustomMarker(marker: marker, state: "finished"));
        });
        break;
      }
    }
  }

  void remove(MarkerId id) {
    for (Marker marker in _markers) {
      if (marker.markerId == id) {
        setState(() {
          _markers.remove(marker);
        });
        break;
      }
    }
    getPolylinePoints(); // Redraw the route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      const InputDecoration(hintText: "Search by location"),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_searchController.text);
                  _goToSearchPlace(place);
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              onTap: (LatLng latLng) {
                _deselectMarker();
                _getTappedPosition(latLng);
                _showInfoWindow(context);
              },

              //add location that show on map
              markers: _markers,
              //add polyline that show on map
              polylines: {
                Polyline(
                    polylineId: const PolylineId('route'),
                    points: polylinePoints)
              },
              //add polygons that show on map
              // polygons: {_polygon},
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  22.334585,
                  114.199754,
                ),
                zoom: 15.5,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
