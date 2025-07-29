import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';

class SearchPlaceController extends GetxController {
  final RxString selectedAddress = ''.obs;
  final RxString selectedPlaceName = ''.obs;

  void clear() {
    selectedAddress.value = '';
    selectedPlaceName.value = '';
  }
}


class MapPage extends StatefulWidget {
  final String? initialKeyword;
  const MapPage({Key? key, this.initialKeyword}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  NLatLng? currentPosition;
  final NLatLng defaultLatLng = NLatLng(35.2322, 129.0844); // 부산대
  late NaverMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  Set<NMarker> _markers = {};

  double itemHeight = 72.0; // ListTile 대략 높이


  final ScrollController _scrollController = ScrollController();


  List<Map<String, dynamic>> _searchResults = [];

  bool _isMapReady = false;

  @override
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }


  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("위치 서비스 켜져 있음");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception("위치 권한 거리됨");
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = NLatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint("\u26a0\ufe0f 현재 위치 가져오기 실패: $e");
      setState(() {
        currentPosition = defaultLatLng; // 실패 시 부산대로
      });
    }
  }

  Map<String, dynamic>? _selectedPlace;


  Future<void> _searchPlace(String query) async {
    final url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?query=$query');
    final response = await http.get(url, headers: {
      'Authorization': 'KakaoAK ${dotenv.env['KAKAO_REST_KEY']}',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final documents = json['documents'];

      if (documents.isNotEmpty) {

        await _mapController.clearOverlays(type: NOverlayType.marker);

        final newMarkers = <NMarker>{};
        final Set<String> markerPositions = {};


        for (var doc in documents.take(30)) {

          final rawLat = double.parse(doc['y']);
          final rawLng = double.parse(doc['x']);
          final name = doc['place_name'];
          final id = doc['id'];

          final lat = double.parse(rawLat.toStringAsFixed(3));
          final lng = double.parse(rawLng.toStringAsFixed(3));
          final key = '$lat,$lng';
          if (markerPositions.contains(key)) continue;

          final marker = NMarker(
            id: id,
            position: NLatLng(lat, lng),
            iconTintColor: Color(0xFF637BB6),
          );

          marker.setOnTapListener((overlay) {
            debugPrint("📍 마커 클릭됨: $name");

            final tappedPlace = {
              'name': name,
              'lat': rawLat,
              'lng': rawLng,
              'address': doc['road_address_name'] ?? '',
            };

            final index = _searchResults.indexWhere((p) =>
            p['lat'] == tappedPlace['lat'] && p['lng'] == tappedPlace['lng']);

            if (index != -1) {
              setState(() {
                _selectedPlace = tappedPlace;
                _isExpanded = true;
              });

              Future.delayed(Duration(milliseconds: 100), () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    index * itemHeight,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });
            }
          });




          newMarkers.add(marker);
          await _mapController.addOverlay(marker);
        }




        final first = json['documents'][0];
        final cameraTarget = NLatLng(
          double.parse(first['y']),
          double.parse(first['x']),
        );

        final cameraUpdate = NCameraUpdate.withParams(
          target: cameraTarget,
          zoom: 15,
        );
        _mapController.updateCamera(cameraUpdate);

        setState(() {
          _markers = newMarkers;
          _searchResults = documents.map<Map<String, dynamic>>((doc) => {
            'name': doc['place_name'],
            'lat': double.parse(doc['y']),
            'lng': double.parse(doc['x']),
            'address': doc['road_address_name'] ?? '',
          }).toList();
          _isExpanded = true;
        });
      } else {
        _showSnackbar("검색 결과가 없습니다");
      }
    } else {
      _showSnackbar("검색 실패. 네트워크나 키 확인");
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(children: [currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: currentPosition!,
            zoom: 15,
          ),
          locationButtonEnable: true,
        ),
        onMapReady: (controller) {
          debugPrint("✅ 네이버 맵 로딩됨!");
          _mapController = controller;
          setState(() {
            _isMapReady = true;
          });
          if (widget.initialKeyword != null && widget.initialKeyword!.isNotEmpty) {
            _searchController.text = widget.initialKeyword!;
            _searchPlace(widget.initialKeyword!);
            _isExpanded = true;
          }
        },
        onMapTapped: (point, latLng) {
          debugPrint("📍 위도: ${latLng.latitude}, 경도: ${latLng.longitude}");
        },
      ),
      Positioned(
          top : 20,
          left : 10,
          right: 10,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: MainColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 2),

              Expanded(child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border:  Border.all(color: Color(0xFFB0BCDA), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: MainColor.withOpacity(0.1),
                        blurRadius: 12.9,
                        offset: Offset(3, 5),
                      ),
                    ],),

                  child: Padding(padding: EdgeInsets.only(left : 15),
                    child : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            cursorColor: MainColor,
                            decoration: InputDecoration(
                              hintText: '장소를 검색하세요',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),

                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),

                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                          ),
                          onPressed: () => _searchPlace(_searchController.text),
                          child: Icon(
                            Icons.search_rounded,
                            color: MainColor,
                            size: 30,
                          ),),
                      ],
                    ),)))
            ],
          )
      ),
        if (_searchResults.isNotEmpty)
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: _isExpanded ? 300 : 50,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    // 접기/펼치기
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Icon(
                        _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      ),
                    ),

                    // 리스트
                    if (_isExpanded)
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(vertical: 0),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final item = _searchResults[index];
                            return Container(
                              color: _selectedPlace?['lat'] == item['lat'] && _selectedPlace?['lng'] == item['lng']
                                  ? const Color(0xFFF2F6FF)
                                  : null,
                              child: ListTile(
                                title: Text(item['name']),
                                subtitle: Text(item['address']),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedPlace = item;
                                    });
                                    final controller = Get.find<SearchPlaceController>();
                                    controller.selectedAddress.value = item['address'];
                                    controller.selectedPlaceName.value = item['name'];
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB0BCDA),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                  child: const Text("선택", style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                                onTap: () {
                                  final latLng = NLatLng(item['lat'], item['lng']);
                                  final update = NCameraUpdate.withParams(
                                    target: latLng,
                                    zoom: 17,
                                  );
                                  _mapController?.updateCamera(update);

                                  final index = _searchResults.indexWhere((p) =>
                                  p['lat'] == item['lat'] && p['lng'] == item['lng']);

                                  if (index != -1) {
                                    setState(() {
                                      _selectedPlace = item;
                                      _isExpanded = true;
                                    });

                                    Future.delayed(Duration(milliseconds: 100), () {
                                      if (_scrollController.hasClients) {
                                        _scrollController.animateTo(
                                          index * itemHeight,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    });
                                  }
                                },

                              ),
                            );

                          },
                        ),

                      ),
                  ],
                ),
              ),
            ),
          ),



      ],),






    );
  }
}
