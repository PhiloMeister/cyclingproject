import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{
  NetworkHelper({required this.startLng,required this.startLat, required this.endLng, required this.endLat});

final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf62485afeed71f08b4739924b681a09925e6e';
  final String pathParam = 'cycling-mountain';// Change it if you want
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
    // http.Response response = await http.get('$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat');
    http.Response response = await http.get(Uri.parse('$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);

    }
    else{
      print(response.statusCode);
    }

  }


}