import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/direction_repository.dart';
import 'package:google_maps/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late GoogleMapController mapController;

  Marker? origin;

  Marker? destination;

  Directions? info;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  addMarker(LatLng position) async {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
        origin = Marker(
            markerId: MarkerId("Origin"),
            infoWindow: InfoWindow(title: "Origin"),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: position);

        destination = null;
        info = null;
      });
    } else {
      setState(() {
        destination = Marker(
            markerId: MarkerId("Destination"),
            infoWindow: InfoWindow(title: "Destination"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: position);
      });
      final direction = await DirectionRepository.getDirection(
          origin!.position, destination!.position);
      setState(() {
        if (direction != null) info = direction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google map"),
        actions: [
          TextButton(
            onPressed: () {
              if (origin != null) {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: origin!.position, zoom: 14.4, tilt: 50)));
              }
            },
            child: Text("Origin"),
          ),
          TextButton(
              onPressed: () {
                if (destination != null) {
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: destination!.position,
                          zoom: 14.4,
                          tilt: 50)));
                }
              },
              child: Text("Destination")),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GoogleMap(
            markers: {
              if (origin != null) origin!,
              if (destination != null) destination!
            },
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) => mapController = controller,
            onLongPress: (LatLng position) {
              addMarker(position);
            },
            onTap: (LatLng position) {
              addMarker(position);
            },
            polylines: {
              if (info != null)
                Polyline(
                  polylineId: PolylineId("overview_polyline"),
                  color: Colors.red,
                  width: 5,
                  points: info!.polylinePoints
                      .map(
                        (e) => LatLng(e.latitude, e.longitude),
                  )
                      .toList(),
                )
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          mapController.animateCamera(
              info != null ? CameraUpdate.newLatLngBounds(info!.bounds, 100) :
              CameraUpdate.newCameraPosition(_kGooglePlex)
          );
        },
        child: Icon(CupertinoIcons.location),
      ),
    );
  }
}
