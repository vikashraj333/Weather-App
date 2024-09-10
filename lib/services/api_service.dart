import 'package:http/http.dart' as http;
import 'package:weather_app/consts/strings.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';




getCurrentWeather(lat, lon) async {
  var link =
    "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = currentWeatherDataFromJson(res.body.toString());
    return data;
  }
}

getHourlyWeather(lat, lon) async {
  var hourlyLink =
    "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(hourlyLink));
  if (res.statusCode == 200) {
    var data = hourlyWeatherDataFromJson(res.body.toString());
    print("data recieved for hourly");
    return data;
  }
}
