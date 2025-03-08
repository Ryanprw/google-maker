import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final LatLng jakartaTimurLocation = const LatLng(-6.2253, 106.9002);
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupMarkers();
  }

  void _setupMarkers() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId("Location Id"),
          position: jakartaTimurLocation,
          alpha: 0.0,
          infoWindow: const InfoWindow(
            title: "Title of the location",
            snippet: "More info about the location",
          ),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: jakartaTimurLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
                _isMapReady = true;
              });
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
          ),
          if (!_isMapReady) const Center(child: CircularProgressIndicator()),

          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: lottie.Lottie.asset(
                'assets/location.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                frameRate: lottie.FrameRate.max,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: jakartaTimurLocation, zoom: 14),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
        tooltip: 'back to',
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
