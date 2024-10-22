import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoder;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';

class Punching extends StatefulWidget {
  const Punching({super.key});

  @override
  State<Punching> createState() => _PunchingState();
}

class _PunchingState extends State<Punching> {
  static const platform = MethodChannel('com.pixl/location');
  double lat = 0.0;
  double lng = 0.0;
  var latlngs = "";
  bool valid_address = true;
  bool punching = true;
  bool _loading = true;

  late String _locationName = "";
  late String _pinCode = "";
  final nonEditableAddressController = TextEditingController();

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  late LatLng initialPosition = LatLng(17.4065, 78.4772);
  late GoogleMapController mapController;
  GoogleMapController? _controller;
  var address_loading = true;
  bool submit =false;

  String status = "";

  DateTime? _lastPressedAt;
  final Duration _exitTime = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
    // GetPuchInStatus();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        _getCurrentLocation();
      } else {
        setState(() {
          _locationName = "Location permission denied.";
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      latlngs = "${lat}, ${lng}";
      initialPosition = LatLng(lat, lng);
      circles.add(Circle(
        circleId: CircleId("user_location_circle"),
        center: initialPosition,
        radius: 100, // Radius in meters
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ));
      _getAddress(lat, lng);
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: initialPosition, zoom: 17),
      ));
    });
  }

  Future<void> _getAddress(double? lat1, double? lng1) async {
    if (lat1 == null || lng1 == null) return;
    List<geocoder.Placemark> placemarks =
        await geocoder.placemarkFromCoordinates(lat1, lng1);

    geocoder.Placemark? validPlacemark;
    for (var placemark in placemarks) {
      if (placemark.country == 'India' &&
          placemark.isoCountryCode == 'IN' &&
          placemark.postalCode != null &&
          placemark.postalCode!.isNotEmpty) {
        validPlacemark = placemark;
        break;
      }
    }
    if (validPlacemark != null) {
      setState(() {
        _locationName =
            "${validPlacemark?.name},${validPlacemark?.subLocality},${validPlacemark?.subAdministrativeArea},"
                    "${validPlacemark?.administrativeArea},${validPlacemark?.postalCode}"
                .toString();
        _pinCode = validPlacemark!.postalCode.toString();
        address_loading = false;
        valid_address = true;
        _loading = false;
      });
    } else {
      // Handle case where no valid placemark is found
      setState(() {
        _locationName =
            "Whoa there, explorer! \nYou've reached a place we haven't. Our services are unavailable here. \nTry another location!";
        address_loading = false;
        valid_address = false;
        _loading = false;
      });
    }
  }

  // Future<void> GetPuchInStatus() async {
  //   final Response = await Userapi.GetPuchInStatusApi();
  //   if (Response != null) {
  //     setState(() {
  //       if (Response.settings?.success == 1) {
  //         status = Response?.status ?? "";
  //       }
  //     });
  //   } else {
  //     _loading = false;
  //   }
  // }

  Future<void> PunchIn() async {
    String location = _locationName;
    String lattitudee = lat.toString();
    String longitudee = lng.toString();
    final punchingResponse =
        await Userapi.PostPunchInAPI(lattitudee, longitudee, location);
    if (punchingResponse != null) {
      setState(() {
        if (punchingResponse.settings?.success == 1) {
          _loading = false;
          punching = !punching;
        }else{
          _loading = false;

        }
      });
    }
  }

  Future<void> PunchOut() async {
    String location = _locationName;
    String lattitudee = lat.toString();
    String longitudee = lng.toString();
    final punchingResponse =
        await Userapi.PostPunchOutAPI(lattitudee, longitudee, location);
    if (punchingResponse != null) {
      setState(() {
        if (punchingResponse.settings?.success == 1) {
          submit=false;
          punching = !punching;
        }else{
          submit=false;
        }
      });
    }
  }


  Future<bool> _onWillPop() async {
    final DateTime now = DateTime.now();
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > _exitTime) {
      _lastPressedAt = now;
      return Future.value(false); // Do not exit the app yet
    }
    return Future.value(true); // Exit the app
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(title: "Punch In/Out", actions: [Container()]),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                color: Color(0xff8856F4),
              ))
            : Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 17.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                    onCameraIdle: () {
                    },
                    markers: markers,
                    circles: circles,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    minMaxZoomPreference: MinMaxZoomPreference(16, null),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: width,
                      height: height * 0.23,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 24, left: 16, right: 16),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location",
                                  style: TextStyle(
                                    color: Color(0xFF465761),
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "$_locationName",
                                  style: TextStyle(
                                    color: Color(0xFF465761),
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: height * 0.03),
                                Center(
                                  child: InkWell(
                                    onTap: () async {
                                      if (status == "Punch in") {
                                        if(submit){

                                        }else{
                                          setState(() {
                                            submit=true;
                                            PunchOut();
                                          });
                                        }
                                      } else {
                                        if(submit){

                                        }else{
                                          setState(() {
                                            submit=true;
                                            PunchIn();
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                      width: width*0.7,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xff8856F4),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Punch In",
                                            style: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Inter"),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          // Image.asset(
                                          //   "assets/fingerPrint.png",
                                          //   fit: BoxFit.contain,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: height * 0.24, // Adjust the position as needed
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.my_location, color: Color(0xff8856F4),),
                            SizedBox(width: 10,),
                            Text(
                              "Locate Me",
                              style: TextStyle(
                                color: Color(0xFF465761),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
