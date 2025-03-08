import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:async';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng myCurrentLocation = LatLng(-6.200000, 106.816666);
  BitmapDescriptor? customIcon;
  GlobalKey _lottieKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
  }

  Future<void> _setCustomMarker() async {
    final Uint8List? markerIcon = await _captureLottieAsBytes();
    if (markerIcon != null) {
      setState(() {
        customIcon = BitmapDescriptor.fromBytes(markerIcon);
      });
    }
  }

  Future<Uint8List?> _captureLottieAsBytes() async {
    RenderRepaintBoundary boundary =
        _lottieKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: myCurrentLocation,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("Marker Id"),
                position: myCurrentLocation,
                draggable: true,
                onDragEnd: (value) {},
                icon: customIcon ?? BitmapDescriptor.defaultMarker,
                infoWindow: const InfoWindow(
                  title: "Title of the maker",
                  snippet: "More info about the maker",
                ),
              ),
            },
          ),

          Positioned(
            top: -1000,
            left: -1000,
            child: RepaintBoundary(
              key: _lottieKey,
              child: SizedBox(
                width: 100,
                height: 100,
                child: lottie.Lottie.asset("assets/location.json"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
