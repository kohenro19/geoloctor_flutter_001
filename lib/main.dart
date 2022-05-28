import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabUI();
  }
}

class TabUI extends StatelessWidget {

  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.location_on)),
  ];

  @override
  Widget build(BuildContext context) {
    int _length = _tabs.length;
    return MaterialApp(
      home: DefaultTabController(
        length: _length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: _tabs,
            ),
            title: Text('Learn Flutter'),
            backgroundColor: Colors.green[200],
          ),
          body: TabBarView(
            children: [
              LocationSample(),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationSample extends StatefulWidget{
  @override
  _LocationSampleState createState() => _LocationSampleState();
}

class _LocationSampleState extends State<LocationSample> {
  // Location
  double latitude = 0;

    @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final p = await _currentPosition;
    setState(() {
        latitude = p.latitude;
    });
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Location Infomation",
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
                Text("Your Current Location is :"),
                Text("$latitude")
              ],
            ),
    );
  }

   Future<Position> get _currentPosition async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効かどうかをテストします。
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 位置情報サービスが有効でない場合、続行できません。
      // 位置情報にアクセスし、ユーザーに対して 
      // 位置情報サービスを有効にするようアプリに要請する。
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // ユーザーに位置情報を許可してもらうよう促す
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 拒否された場合エラーを返す
        return Future.error('Location permissions are denied');
      }
    }
    
    // 永久に拒否されている場合のエラーを返す
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // ここまでたどり着くと、位置情報に対しての権限が許可されているということなので
    // デバイスの位置情報を返す。
    // return await Geolocator.getCurrentPosition();
 
    final position = await Geolocator.getCurrentPosition();
    final placeMarks = await geoCoding.placemarkFromCoordinates(position.latitude, position.longitude);

    final placeMark = placeMarks[0];

    // return placeMark.country;
    return position;
 }

}
