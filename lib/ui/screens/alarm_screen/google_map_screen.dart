import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/globals.dart';
import '../../../data/router/app_state.dart';
import '../../../logic/provider/user_provider.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    required this.lat,
    required this.lng,
    required this.address,
    required this.bankName,
    required this.branchName,
    required this.eId,
  }) : super(key: key);
  // NotificationModel notification;
  String lat;
  String lng;
  String address;
  String bankName;
  String branchName;
  int eId;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final _initialCameraPosition;

  setUpMarker() async {
    var currentLocationCamera = LatLng(double.parse(widget.lat), double.parse(widget.lat));

    final pickupMarker = Marker(markerId: MarkerId("${currentLocationCamera.latitude}"), position: LatLng(currentLocationCamera.latitude, currentLocationCamera.longitude));
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      // target: LatLng(double.parse(""), double.parse("")),
      target: LatLng(double.parse(widget.lat), double.parse(widget.lng)),
      zoom: 11.5,
    );
  }

  bool isLoadingCheck = false;

  Future<void> setResponse(String? status) async {
    setState(() {
      isLoadingCheck = true;
    });
    var setResponseJsonBody = jsonEncode(<String, String>{
      'emergencyID': widget.eId.toString(),
      'clientStatus': status.toString(),
      "channelUserID": context.read<UserProvider>().loggedInUserModal!.id.toString(),
    });

    var url = 'https://qa-er-notificationapi';
    if (!await InternetConnectionChecker().hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No Internet'),
        duration: Duration(milliseconds: 500),
      ));
      setState(() {
        isLoadingCheck = false;
      });
    } else {
      try {
        http.Response response = await http.post(
          Uri.parse(url),
          body: setResponseJsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          var getDataFromJsonResponse = jsonDecode(response.body);

          // for (var item in getDataFromJsonResponse) {
          //   var userValue = UserModel.fromJson(item);
          //   context.read<UserProvider>().addUser(context, userValue);
          // }
          print('aftab');
          print(getDataFromJsonResponse);
          setState(() {
            isLoadingCheck = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong'),
            duration: Duration(milliseconds: 500),
          ));
          setState(() {
            isLoadingCheck = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoadingCheck = false;
        });
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 600.h,
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                // markers: setUpMarker,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Caller information:",
                    style: TextStyle(color: Colors.red, fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Bank Name: ",
                        style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " ${widget.bankName}:",
                        style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Branch Name: ",
                        style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          " ${widget.branchName}:",
                          style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Address: ",
                        style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " ${widget.address}:",
                        style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await setResponse('R');
                          AppState appState = sl();
                          appState.moveToBackScreen();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: const Text('Respond'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await setResponse('C');
                          AppState appState = sl();

                          appState.moveToBackScreen();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
